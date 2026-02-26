import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract final class GeoMath {
  static const double _earthRadiusMeters = 6371000;

  static double haversineMeters(LatLng a, LatLng b) {
    final double lat1 = _toRad(a.latitude);
    final double lat2 = _toRad(b.latitude);
    final double dLat = _toRad(b.latitude - a.latitude);
    final double dLng = _toRad(b.longitude - a.longitude);

    final double h = math.pow(math.sin(dLat / 2), 2).toDouble() +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLng / 2), 2).toDouble();
    final double c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
    return _earthRadiusMeters * c;
  }

  static List<LatLng> smooth(List<LatLng> points, {int window = 4}) {
    if (points.length <= 2 || window <= 1) {
      return points;
    }

    final List<LatLng> out = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      final int start = math.max(0, i - window + 1);
      final int end = i + 1;
      double sumLat = 0;
      double sumLng = 0;
      int count = 0;
      for (int j = start; j < end; j++) {
        sumLat += points[j].latitude;
        sumLng += points[j].longitude;
        count++;
      }
      out.add(LatLng(sumLat / count, sumLng / count));
    }
    return out;
  }

  static double _toRad(double degree) => degree * math.pi / 180;
}
