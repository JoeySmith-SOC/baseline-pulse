enum DistanceUnit { miles, kilometers }

abstract final class UnitFormat {
  static DistanceUnit localeDefault(String localeTag) {
    final String normalized = localeTag.toLowerCase();
    return normalized.startsWith('en-us') || normalized.startsWith('en_us')
        ? DistanceUnit.miles
        : DistanceUnit.kilometers;
  }

  static String unitLabel(DistanceUnit unit) {
    return unit == DistanceUnit.miles ? 'mi' : 'km';
  }

  static double metersToUnit(double meters, DistanceUnit unit) {
    return unit == DistanceUnit.miles ? meters / 1609.344 : meters / 1000;
  }

  static double unitToMeters(double value, DistanceUnit unit) {
    return unit == DistanceUnit.miles ? value * 1609.344 : value * 1000;
  }

  static double splitLengthMeters(DistanceUnit unit) {
    return unit == DistanceUnit.miles ? 1609.344 : 1000;
  }

  static String formatDistance(double meters, DistanceUnit unit) {
    return '${metersToUnit(meters, unit).toStringAsFixed(2)} ${unitLabel(unit)}';
  }
}
