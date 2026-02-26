import 'package:intl/intl.dart';

abstract final class DateFormatUtil {
  static String timestamp(DateTime value) {
    return DateFormat.yMMMd().add_jm().format(value.toLocal());
  }

  static String duration(Duration value) {
    final int hours = value.inHours;
    final int mins = value.inMinutes % 60;
    final int secs = value.inSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
