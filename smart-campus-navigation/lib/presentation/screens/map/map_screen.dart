import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/map_constants.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/location_utils.dart';
import '../../../domain/entities/building.dart';
import '../../../domain/entities/landmark.dart';
import '../../providers/location_provider.dart';
import '../../providers/map_provider.dart';
import '../../providers/metrics_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/navigation/route_info_widget.dart';
import '../../widgets/navigation/turn_by_turn_widget.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  mapbox.MapboxMap? _mapboxMap;
  String? _overlaySignature;
  ProviderSubscription<AsyncValue<Position>>? _locationSubscription;
  bool _autoIndoorTransitionInProgress = false;
    bool _isSatellite = false;
    List<Building> _poiBuildings = const [];
    List<Landmark> _poiLandmarks = const [];

  @override
  void initState() {
    super.initState();
    _locationSubscription = ref.listenManual<AsyncValue<Position>>(
      locationStreamProvider,
      (previous, next) {
        next.whenData(_handleLivePositionUpdate);
      },
    );
  }

  @override
  void dispose() {
    _locationSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeRoute = ref.watch(activeRouteProvider);
    final isNavigating = ref.watch(isNavigatingProvider);
    final currentStep = ref.watch(currentStepIndexProvider);
    final pendingIndoor = ref.watch(pendingIndoorNavigationProvider);
    final currentPosition = ref.watch(currentPositionProvider);
    final campusData = ref.watch(campusDataProvider);

    final canContinueIndoors = pendingIndoor != null &&
        currentPosition.maybeWhen(
          data: (position) {
            if (position == null) return true;
            return LocationUtils.isWithinRadius(
              position.latitude,
              position.longitude,
              pendingIndoor.entranceLatitude,
              pendingIndoor.entranceLongitude,
              AppConstants.buildingEntranceRadius,
            );
          },
          orElse: () => true,
        );

    final campusSignature = campusData.maybeWhen(
      data: (data) => '${data.buildings.length}|${data.landmarks.length}',
      orElse: () => 'loading',
    );

    _scheduleOverlaySync(activeRoute, pendingIndoor, campusSignature);

    return Scaffold(
      body: Stack(
        children: [
          // â”€â”€ Mapbox Map â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          mapbox.MapWidget(
            styleUri: MapConstants.styleStreets,
            cameraOptions: mapbox.CameraOptions(
              center: mapbox.Point(
                coordinates: mapbox.Position(
                  MapConstants.defaultLongitude,
                  MapConstants.defaultLatitude,
                ),
              ),
              zoom: MapConstants.defaultZoom,
            ),            onTapListener: _onMapTap,
            onMapCreated: (map) async {
              _mapboxMap = map;
              await map.location.updateSettings(
                mapbox.LocationComponentSettings(
                  enabled: true,
                  pulsingEnabled: true,
                ),
              );
              await _renderCampusBaseLayers();
              await _syncDynamicOverlays();
            },
          ),

          // â”€â”€ Turn-by-turn overlay (when navigating) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          if (isNavigating && activeRoute != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: TurnByTurnWidget(
                route: activeRoute,
                currentStepIndex: currentStep,
                onDismiss: () {
                  ref.read(isNavigatingProvider.notifier).state = false;
                  ref.read(activeRouteProvider.notifier).state = null;
                  ref.read(currentStepIndexProvider.notifier).state = 0;
                },
              ),
            ),

          // â”€â”€ Route preview panel (before starting navigation) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          if (!isNavigating && activeRoute != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RouteInfoWidget(
                route: activeRoute,
                routeTypeLabel: pendingIndoor != null
                    ? 'Outdoor route to entrance'
                    : null,
                helperText: pendingIndoor != null
                    ? canContinueIndoors
                        ? 'Entrance reached. Continue indoors to ${pendingIndoor.destinationName}.'
                        : 'Head to ${pendingIndoor.entranceLabel}, then continue indoors to ${pendingIndoor.destinationName}.'
                    : null,
                onStartNavigation: () {
                  ref.read(isNavigatingProvider.notifier).state = true;
                },
                onSecondaryAction: pendingIndoor != null
                    ? () => _openIndoorContinuation(context, pendingIndoor)
                    : null,
                secondaryActionLabel: pendingIndoor != null
                    ? (canContinueIndoors
                        ? 'Continue Indoors'
                        : 'Open Indoor Preview')
                    : null,
                onClose: () {
                  ref.read(activeRouteProvider.notifier).state = null;
                  ref.read(pendingIndoorNavigationProvider.notifier).state =
                      null;
                },
              ),
            ),

          // â”€â”€ Recenter FAB â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          if (!isNavigating)
            Positioned(
              right: 16,
              bottom: activeRoute != null ? 200 : 80,
              child: FloatingActionButton.small(
                heroTag: 'recenter',
                onPressed: _recenter,
                child: const Icon(Icons.my_location),
              ),
            ),

            // â”€â”€ Satellite / Streets toggle FAB â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            if (!isNavigating)
              Positioned(
                right: 16,
                bottom: activeRoute != null ? 252 : 132,
                child: Tooltip(
                  message: _isSatellite ? 'Streets view' : 'Satellite view',
                  child: FloatingActionButton.small(
                    heroTag: 'satellite',
                    onPressed: _toggleSatellite,
                    backgroundColor: _isSatellite
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: Icon(
                      _isSatellite ? Icons.map_outlined : Icons.satellite_alt,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Future<void> _recenter() async {
    if (_mapboxMap == null) return;
    final pos = await ref.read(locationServiceProvider).getCurrentPosition();
    if (pos == null) return;

    await _mapboxMap!.flyTo(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(pos.longitude, pos.latitude),
        ),
        zoom: MapConstants.defaultZoom,
      ),
      mapbox.MapAnimationOptions(duration: 800),
    );
  }

  void _handleLivePositionUpdate(Position position) {
    final pendingIndoor = ref.read(pendingIndoorNavigationProvider);
    if (pendingIndoor == null || _autoIndoorTransitionInProgress || !mounted) {
      return;
    }

    final hasReachedEntrance = LocationUtils.isWithinRadius(
      position.latitude,
      position.longitude,
      pendingIndoor.entranceLatitude,
      pendingIndoor.entranceLongitude,
      AppConstants.buildingEntranceRadius,
    );

    if (!hasReachedEntrance) return;

    _autoIndoorTransitionInProgress = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _openIndoorContinuation(context, pendingIndoor, autoTriggered: true);
      _autoIndoorTransitionInProgress = false;
    });
  }

  void _scheduleOverlaySync(
    dynamic activeRoute,
    PendingIndoorNavigation? pendingIndoor,
    String campusSignature,
  ) {
    final signature = [
      activeRoute?.destinationId,
      activeRoute?.waypoints.length,
      activeRoute?.isIndoor,
      pendingIndoor?.buildingId,
      pendingIndoor?.destinationNodeId,
      campusSignature,
    ].join('|');

    if (_overlaySignature == signature) return;
    _overlaySignature = signature;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _syncDynamicOverlays();
    });
  }

  Future<void> _renderCampusBaseLayers() async {
    final map = _mapboxMap;
    if (map == null) return;

    final raw = await rootBundle.loadString('assets/maps/campus_outdoor.geojson');

    try {
      await map.style.removeStyleLayer(MapConstants.campusOutdoorPointLayer);
      await map.style.removeStyleLayer(MapConstants.campusOutdoorLineLayer);
      await map.style.removeStyleLayer(MapConstants.campusOutdoorFillLayer);
      await map.style.removeStyleSource(MapConstants.campusOutdoorSource);
    } on Exception {
      // Base layers may not exist yet.
    }

    await map.style.addSource(mapbox.GeoJsonSource(
      id: MapConstants.campusOutdoorSource,
      data: raw,
    ));

    await map.style.addLayer(mapbox.FillLayer(
      id: MapConstants.campusOutdoorFillLayer,
      sourceId: MapConstants.campusOutdoorSource,
      fillColor: 0x2234A853,
      fillOutlineColor: 0xFF2E7D32,
    ));

    await map.style.addLayer(mapbox.LineLayer(
      id: MapConstants.campusOutdoorLineLayer,
      sourceId: MapConstants.campusOutdoorSource,
      lineColor: 0xFF2E7D32,
      lineWidth: 1.5,
    ));

    await map.style.addLayer(mapbox.CircleLayer(
      id: MapConstants.campusOutdoorPointLayer,
      sourceId: MapConstants.campusOutdoorSource,
      circleColor: 0xFF1A73E8,
      circleRadius: 5.0,
      circleStrokeColor: 0xFFFFFFFF,
      circleStrokeWidth: 1.5,
    ));
  }

  Future<void> _syncDynamicOverlays() async {
    final map = _mapboxMap;
    if (map == null) return;

    final activeRoute = ref.read(activeRouteProvider);
    final pendingIndoor = ref.read(pendingIndoorNavigationProvider);
    final campusAsync = ref.read(campusDataProvider);

    if (campusAsync.hasValue) {
      final data = campusAsync.requireValue;
        _poiBuildings = data.buildings;
        _poiLandmarks = data.landmarks;
      await _renderCampusPois(data.buildings, data.landmarks);
    }
    await _renderOutdoorRoute(activeRoute);
    await _renderEntranceHandoffMarker(pendingIndoor);
  }

  Future<void> _renderCampusPois(
    List<Building> buildings,
    List<Landmark> landmarks,
  ) async {
    final map = _mapboxMap;
    if (map == null) return;

    final features = <Map<String, dynamic>>[
      ...buildings.map(
        (b) => {
          'type': 'Feature',
          'properties': {
            'name': b.name,
            'kind': 'building',
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [b.longitude, b.latitude],
          },
        },
      ),
      ...landmarks.map(
        (l) => {
          'type': 'Feature',
          'properties': {
            'name': l.name,
            'kind': 'landmark',
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [l.longitude, l.latitude],
          },
        },
      ),
    ];

    final geoJson = {
      'type': 'FeatureCollection',
      'features': features,
    };

    try {
      await map.style.removeStyleLayer(MapConstants.campusPoiLabelLayer);
      await map.style.removeStyleLayer(MapConstants.campusPoiLayer);
      await map.style.removeStyleSource(MapConstants.campusPoiSource);
    } on Exception {
      // POI source/layers may not exist yet.
    }

    await map.style.addSource(mapbox.GeoJsonSource(
      id: MapConstants.campusPoiSource,
      data: jsonEncode(geoJson),
    ));

    await map.style.addLayer(mapbox.CircleLayer(
      id: MapConstants.campusPoiLayer,
      sourceId: MapConstants.campusPoiSource,
      circleColor: 0xFF0F9D58,
      circleRadius: 6.0,
      circleStrokeColor: 0xFFFFFFFF,
      circleStrokeWidth: 1.5,
    ));

    await map.style.addLayer(mapbox.SymbolLayer(
      id: MapConstants.campusPoiLabelLayer,
      sourceId: MapConstants.campusPoiSource,
      textField: '{name}',
      textSize: 11.0,
      textColor: 0xFF202124,
      textHaloColor: 0xFFFFFFFF,
      textHaloWidth: 1.0,
      textOffset: [0.0, 1.2],
      textAllowOverlap: false,
      textIgnorePlacement: false,
    ));
  }

  Future<void> _renderOutdoorRoute(dynamic activeRoute) async {
    final map = _mapboxMap;
    if (map == null) return;

    try {
      await map.style.removeStyleLayer(MapConstants.routeLayer);
      await map.style.removeStyleSource(MapConstants.routeSource);
    } on Exception {
      // Route layer/source may not exist yet.
    }

    if (activeRoute == null || activeRoute.isIndoor == true) return;

    final geoJson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': {},
          'geometry': {
            'type': 'LineString',
            'coordinates': activeRoute.waypoints,
          },
        }
      ],
    };

    await map.style.addSource(mapbox.GeoJsonSource(
      id: MapConstants.routeSource,
      data: jsonEncode(geoJson),
    ));

    await map.style.addLayer(mapbox.LineLayer(
      id: MapConstants.routeLayer,
      sourceId: MapConstants.routeSource,
      lineColor: MapConstants.routeLineColor,
      lineWidth: MapConstants.routeLineWidth,
      lineOpacity: 0.92,
      lineCap: mapbox.LineCap.ROUND,
      lineJoin: mapbox.LineJoin.ROUND,
    ));
  }

  Future<void> _renderEntranceHandoffMarker(
    PendingIndoorNavigation? pendingIndoor,
  ) async {
    final map = _mapboxMap;
    if (map == null) return;

    try {
      await map.style.removeStyleLayer(MapConstants.entranceHandoffLayer);
      await map.style.removeStyleSource(MapConstants.entranceHandoffSource);
    } on Exception {
      // Handoff layer/source may not exist yet.
    }

    if (pendingIndoor == null) return;

    final geoJson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': {
            'label': pendingIndoor.entranceLabel,
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [
              pendingIndoor.entranceLongitude,
              pendingIndoor.entranceLatitude,
            ],
          },
        }
      ],
    };

    await map.style.addSource(mapbox.GeoJsonSource(
      id: MapConstants.entranceHandoffSource,
      data: jsonEncode(geoJson),
    ));

    await map.style.addLayer(mapbox.CircleLayer(
      id: MapConstants.entranceHandoffLayer,
      sourceId: MapConstants.entranceHandoffSource,
      circleColor: 0xFFEA4335,
      circleRadius: 7.0,
      circleStrokeColor: 0xFFFFFFFF,
      circleStrokeWidth: 2.0,
    ));
  }

  void _openIndoorContinuation(
    BuildContext context,
    PendingIndoorNavigation pendingIndoor,
    {bool autoTriggered = false,
    }
  ) {
    ref.read(isNavigatingProvider.notifier).state = false;
    ref.read(currentStepIndexProvider.notifier).state = 0;
    ref.read(pendingIndoorNavigationProvider.notifier).state = null;

    if (autoTriggered) {
      ref.read(metricsServiceProvider).logEvent(
        'indoor_handoff_auto_triggered',
        properties: {
          'buildingId': pendingIndoor.buildingId,
          'floorNumber': pendingIndoor.floorNumber,
          'destinationNodeId': pendingIndoor.destinationNodeId,
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Entrance reached. Continuing indoors to ${pendingIndoor.destinationName}.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ref.read(metricsServiceProvider).logEvent(
        'indoor_handoff_manual_opened',
        properties: {
          'buildingId': pendingIndoor.buildingId,
          'floorNumber': pendingIndoor.floorNumber,
          'destinationNodeId': pendingIndoor.destinationNodeId,
        },
      );
    }

    context.go(
      '${RouteConstants.home}/${RouteConstants.indoorMap}',
      extra: {
        'buildingId': pendingIndoor.buildingId,
        'floorNumber': pendingIndoor.floorNumber,
        'destinationNodeId': pendingIndoor.destinationNodeId,
      },
    );
  }

  // â”€â”€ Satellite / streets style toggle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _toggleSatellite() async {
    final map = _mapboxMap;
    if (map == null) return;
    setState(() => _isSatellite = !_isSatellite);
    final styleUri =
        _isSatellite ? MapConstants.styleSatellite : MapConstants.styleStreets;
    await map.loadStyleURI(styleUri);
    await _renderCampusBaseLayers();
    await _syncDynamicOverlays();
  }

  // â”€â”€ Map tap â†’ detect nearby POI and show detail sheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _onMapTap(mapbox.MapContentGestureContext context) {
    final tapLat = context.point.coordinates.lat.toDouble();
    final tapLng = context.point.coordinates.lng.toDouble();
    const double tapThresholdM = 80.0;

    Building? nearB;
    double nearBDist = double.infinity;
    for (final b in _poiBuildings) {
      final d = LocationUtils.distanceInMetres(tapLat, tapLng, b.latitude, b.longitude);
      if (d < nearBDist) {
        nearBDist = d;
        nearB = b;
      }
    }

    Landmark? nearL;
    double nearLDist = double.infinity;
    for (final l in _poiLandmarks) {
      final d = LocationUtils.distanceInMetres(tapLat, tapLng, l.latitude, l.longitude);
      if (d < nearLDist) {
        nearLDist = d;
        nearL = l;
      }
    }

    if (nearBDist <= nearLDist && nearBDist <= tapThresholdM && nearB != null) {
      _showPoiDetail(
        name: nearB.name,
        description: nearB.description,
        type: 'building',
        imageUrl: nearB.imageUrl,
        lat: nearB.latitude,
        lng: nearB.longitude,
      );
    } else if (nearLDist <= tapThresholdM && nearL != null) {
      _showPoiDetail(
        name: nearL.name,
        description: nearL.description,
        type: nearL.type,
        imageUrl: nearL.imageUrl,
        openingHours: nearL.openingHours,
        lat: nearL.latitude,
        lng: nearL.longitude,
      );
    }
  }

  // â”€â”€ POI Detail bottom sheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _showPoiDetail({
    required String name,
    required String description,
    required String type,
    String? imageUrl,
    String? openingHours,
    double lat = 0.0,
    double lng = 0.0,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.88,
        builder: (_, scrollCtrl) => Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: EdgeInsets.zero,
                children: [
                  // â”€â”€ Hero image â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  SizedBox(
                    height: 190,
                    width: double.infinity,
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _poiImagePlaceholder(
                                type, Theme.of(ctx)),
                            errorWidget: (_, __, ___) =>
                                _poiImagePlaceholder(type, Theme.of(ctx)),
                          )
                        : _poiImagePlaceholder(type, Theme.of(ctx)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type chip
                        Row(
                          children: [
                            Chip(
                              avatar: Icon(_iconForType(type),
                                  size: 15,
                                  color: _colorForType(type)),
                              label: Text(
                                _labelForType(type),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _colorForType(type),
                                    fontWeight: FontWeight.w600),
                              ),
                              backgroundColor:
                                  _colorForType(type).withValues(alpha: 0.12),
                              side: BorderSide.none,
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Name
                        Text(
                          name,
                          style: Theme.of(ctx)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Description
                        Text(description,
                            style: Theme.of(ctx).textTheme.bodyMedium),
                        // Opening hours
                        if (openingHours != null) ...[
                          const SizedBox(height: 10),
                          Row(children: [
                            Icon(Icons.access_time_outlined,
                                size: 16,
                                color: Theme.of(ctx)
                                    .colorScheme
                                    .onSurfaceVariant),
                            const SizedBox(width: 6),
                            Text(openingHours,
                                style: Theme.of(ctx)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Theme.of(ctx)
                                            .colorScheme
                                            .onSurfaceVariant)),
                          ]),
                        ],
                        const SizedBox(height: 20),
                        // Navigate button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _flyToLocation(lat, lng);
                            },
                            icon: const Icon(Icons.directions),
                            label: const Text('Navigate Here'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _poiImagePlaceholder(String type, ThemeData theme) {
    return Container(
      color: _colorForType(type).withValues(alpha: 0.10),
      child: Center(
        child: Icon(_iconForType(type),
            size: 72, color: _colorForType(type).withValues(alpha: 0.5)),
      ),
    );
  }

  Future<void> _flyToLocation(double lat, double lng) async {
    final map = _mapboxMap;
    if (map == null) return;
    await map.flyTo(
      mapbox.CameraOptions(
        center: mapbox.Point(coordinates: mapbox.Position(lng, lat)),
        zoom: 17.5,
      ),
      mapbox.MapAnimationOptions(duration: 800),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'building':
        return Icons.apartment;
      case 'food':
        return Icons.restaurant;
      case 'emergency':
        return Icons.local_hospital;
      case 'sports':
        return Icons.sports_basketball;
      case 'transport':
        return Icons.directions_bus;
      case 'outdoor':
        return Icons.park;
      default:
        return Icons.place;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'building':
        return Colors.blue;
      case 'food':
        return Colors.orange;
      case 'emergency':
        return Colors.red;
      case 'sports':
        return Colors.green;
      case 'transport':
        return const Color(0xFF7B1FA2);
      case 'outdoor':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _labelForType(String type) {
    switch (type) {
      case 'building':
        return 'Building';
      case 'food':
        return 'Food & Dining';
      case 'emergency':
        return 'Medical';
      case 'sports':
        return 'Sports';
      case 'transport':
        return 'Transport';
      case 'outdoor':
        return 'Outdoor';
      default:
        return 'Campus Point';
    }
  }
}
