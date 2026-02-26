import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:share_plus/share_plus.dart';

class RuckShareCard {
  Future<void> share(RuckSession session) async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Ruck ${session.distanceMeters.toStringAsFixed(0)}m | '
            '${session.ruckWeightLbs.toStringAsFixed(1)} lbs | '
            'Selection: ${session.selectionMode ? 'On' : 'Off'}',
      ),
    );
  }
}
