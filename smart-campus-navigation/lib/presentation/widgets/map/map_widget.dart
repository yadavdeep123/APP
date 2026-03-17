import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

import '../../../core/constants/map_constants.dart';
import '../../../domain/entities/landmark.dart';
import '../../../domain/entities/route.dart' as domain;

class MapWidget extends ConsumerStatefulWidget {
  const MapWidget({
    super.key,
    this.landmarks = const [],
    this.activeRoute,
    this.onMapCreated,
    this.onLandmarkTapped,
  });

  final List<Landmark> landmarks;
  final domain.Route? activeRoute;
  final void Function(mapbox.MapboxMap)? onMapCreated;
  final void Function(Landmark)? onLandmarkTapped;

  @override
  ConsumerState<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return mapbox.MapWidget(
      key: const ValueKey('mapbox_map'),
      styleUri: MapConstants.styleStreets,
      cameraOptions: mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(
            MapConstants.defaultLongitude,
            MapConstants.defaultLatitude,
          ),
        ),
        zoom: MapConstants.defaultZoom,
      ),
      onMapCreated: (map) {
        widget.onMapCreated?.call(map);
        _initializeLayers(map);
      },
    );
  }

  Future<void> _initializeLayers(mapbox.MapboxMap map) async {
    // Enable location puck (blue dot)
    await map.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
      ),
    );

    if (widget.activeRoute != null) {
      await _drawRoute(map, widget.activeRoute!);
    }
  }

  Future<void> _drawRoute(mapbox.MapboxMap map, domain.Route route) async {
    final coords = route.waypoints
        .map((w) => [w[0], w[1]])
        .toList();

    final geoJson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'geometry': {
            'type': 'LineString',
            'coordinates': coords,
          },
          'properties': {},
        }
      ],
    };

    await map.style.addSource(mapbox.GeoJsonSource(
      id: MapConstants.routeSource,
      data: geoJson.toString(),
    ));

    await map.style.addLayer(mapbox.LineLayer(
      id: MapConstants.routeLayer,
      sourceId: MapConstants.routeSource,
      lineColor: MapConstants.routeLineColor,
      lineWidth: MapConstants.routeLineWidth,
      lineCap: mapbox.LineCap.ROUND,
      lineJoin: mapbox.LineJoin.ROUND,
    ));
  }
}
