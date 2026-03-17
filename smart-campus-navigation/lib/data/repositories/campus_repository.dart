import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/map_constants.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/landmark.dart';
import '../services/google_places_service.dart';

/// Loads campus data from local asset JSON files.
/// This is the single source of truth for buildings and landmarks.
class CampusRepository {
  List<Building>? _buildingsCache;
  List<Landmark>? _landmarksCache;
  final GooglePlacesService _googlePlacesService = GooglePlacesService();
  final Box? _campusCacheBox = Hive.isBoxOpen(AppConstants.campusCacheBox)
      ? Hive.box(AppConstants.campusCacheBox)
      : null;

  Future<List<Building>> getBuildings() async {
    if (_buildingsCache != null) return _buildingsCache!;

    final raw = await _loadJsonWithFallback(
      assetPath: 'assets/data/campus_info.json',
      cacheKey: AppConstants.campusInfoCacheKey,
    );
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final buildingsJson = json['buildings'] as List<dynamic>? ?? [];

    final buildings = <Building>[];

    for (final b in buildingsJson) {
      final bMap = b as Map<String, dynamic>;
      final floorsJson = bMap['floors'] as List<dynamic>? ?? [];
      final buildingId =
          bMap['name'].toString().toLowerCase().replaceAll(' ', '_');
      final entrances = <Entrance>[];
      final floors = <Floor>[];

      for (final f in floorsJson) {
        final fMap = f as Map<String, dynamic>;
        final floorNum = fMap['floor_number'] as int;
        final assetPath =
            'assets/maps/buildings/${buildingId}_floor$floorNum.geojson';
        final indoorNodes = await _loadIndoorNodesForFloor(
          assetPath: assetPath,
          buildingId: buildingId,
          floorNumber: floorNum,
        );

        floors.add(
          Floor(
            floorNumber: floorNum,
            label: 'Floor $floorNum',
            buildingId: buildingId,
            geojsonAssetPath: assetPath,
            rooms: indoorNodes.rooms,
          ),
        );

        entrances.addAll(indoorNodes.entrances);
      }

      buildings.add(Building(
        id: buildingId,
        name: bMap['name'] as String,
        description: bMap['description'] as String,
        latitude: (bMap['coordinates']['latitude'] as num).toDouble(),
        longitude: (bMap['coordinates']['longitude'] as num).toDouble(),
        floors: floors,
        entrances: entrances,
          imageUrl: bMap['imageUrl'] as String?,
      ));
    }

    _buildingsCache = buildings;

    return _buildingsCache!;
  }

  Future<List<Landmark>> getLandmarks() async {
    if (_landmarksCache != null) return _landmarksCache!;

    final raw = await _loadJsonWithFallback(
      assetPath: 'assets/data/landmarks.json',
      cacheKey: AppConstants.landmarksCacheKey,
    );
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final landmarksJson = json['landmarks'] as List<dynamic>? ?? [];

    final localLandmarks = landmarksJson.map((l) {
      final lMap = l as Map<String, dynamic>;
      return Landmark(
        id: lMap['id'] as int,
        name: lMap['name'] as String,
        description: lMap['description'] as String,
        latitude: (lMap['coordinates']['latitude'] as num).toDouble(),
        longitude: (lMap['coordinates']['longitude'] as num).toDouble(),
        type: lMap['type'] as String,
          imageUrl: lMap['imageUrl'] as String?,
          openingHours: lMap['openingHours'] as String?,
      );
    }).toList();

    _landmarksCache = localLandmarks;

    // Optional Google Places sync: merge live POIs near campus center.
    try {
      final campusLocation =
          (await _readCampusLocation()) ?? (MapConstants.defaultLatitude, MapConstants.defaultLongitude);
      final googleLandmarks = await _googlePlacesService.fetchNearbyCampusLandmarks(
        latitude: campusLocation.$1,
        longitude: campusLocation.$2,
      );
      if (googleLandmarks.isNotEmpty) {
        _landmarksCache = _googlePlacesService.mergeDeduplicated(
          base: localLandmarks,
          google: googleLandmarks,
        );
      }
    } catch (_) {
      // Non-fatal. Keep local dataset when Google sync fails.
    }

    return _landmarksCache!;
  }

  /// Clears in-memory caches (useful for testing).
  void clearCache() {
    _buildingsCache = null;
    _landmarksCache = null;
  }

  Future<String> _loadJsonWithFallback({
    required String assetPath,
    required String cacheKey,
  }) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      _campusCacheBox?.put(cacheKey, raw);
      return raw;
    } catch (_) {
      final cached = _campusCacheBox?.get(cacheKey);
      if (cached is String && cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<(double, double)?> _readCampusLocation() async {
    try {
      final raw = await _loadJsonWithFallback(
        assetPath: 'assets/data/campus_info.json',
        cacheKey: AppConstants.campusInfoCacheKey,
      );
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final campus = json['campus_location'] as Map<String, dynamic>?;
      if (campus == null) return null;

      return (
        (campus['latitude'] as num).toDouble(),
        (campus['longitude'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<_IndoorFloorNodes> _loadIndoorNodesForFloor({
    required String assetPath,
    required String buildingId,
    required int floorNumber,
  }) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final features = json['features'] as List<dynamic>? ?? [];

      final rooms = <Room>[];
      final entrances = <Entrance>[];

      for (final feature in features) {
        final featureMap = feature as Map<String, dynamic>;
        final props = featureMap['properties'] as Map<String, dynamic>? ?? {};
        final geometry = featureMap['geometry'] as Map<String, dynamic>? ?? {};
        if (geometry['type'] != 'Point') continue;

        final nodeType = props['node_type'] as String?;
        final coords = geometry['coordinates'] as List<dynamic>?;
        if (coords == null || coords.length < 2) continue;

        final longitude = (coords[0] as num).toDouble();
        final latitude = (coords[1] as num).toDouble();
        final id = props['id'] as String?;
        final name = props['name'] as String?;

        if (id == null || name == null) continue;

        if (nodeType == 'room') {
          rooms.add(
            Room(
              id: id,
              name: name,
              type: 'room',
              buildingId: buildingId,
              floorNumber: floorNumber,
              latitude: latitude,
              longitude: longitude,
              description: props['description'] as String?,
              roomNumber: props['room_number'] as String?,
            ),
          );
        }

        if (nodeType == 'entrance') {
          entrances.add(
            Entrance(
              id: id,
              label: name,
              latitude: latitude,
              longitude: longitude,
            ),
          );
        }
      }

      return _IndoorFloorNodes(rooms: rooms, entrances: entrances);
    } catch (_) {
      return const _IndoorFloorNodes(rooms: [], entrances: []);
    }
  }
}

class _IndoorFloorNodes {
  const _IndoorFloorNodes({
    required this.rooms,
    required this.entrances,
  });

  final List<Room> rooms;
  final List<Entrance> entrances;
}
