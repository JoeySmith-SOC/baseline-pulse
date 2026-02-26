import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRouteView extends StatelessWidget {
  const MapRouteView({super.key, required this.route});

  final List<LatLng> route;

  @override
  Widget build(BuildContext context) {
    final LatLng center = route.isNotEmpty
        ? route.last
        : const LatLng(37.4219999, -122.0840575);

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: center, zoom: 15),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      polylines: <Polyline>{
        Polyline(
          polylineId: const PolylineId('session_route'),
          color: const Color(0xFFE5252A),
          width: 4,
          points: route,
        ),
      },
    );
  }
}
