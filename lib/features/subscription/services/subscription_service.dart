import 'package:baseline_pulse/features/subscription/models/entitlement_state.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  SubscriptionService({required this.mockMode});

  final bool mockMode;

  EntitlementState _state = const EntitlementState(
    isPremium: false,
    features: <PremiumFeatureFlag>{},
  );

  EntitlementState get state => _state;

  Future<void> initialize() async {
    if (mockMode) {
      return;
    }
    // Future: configure Purchases with API key from secure local config.
  }

  Future<void> refresh() async {
    if (mockMode) {
      _state = const EntitlementState(isPremium: false, features: <PremiumFeatureFlag>{});
      return;
    }

    try {
      final CustomerInfo info = await Purchases.getCustomerInfo();
      final bool premium = info.entitlements.active.isNotEmpty;
      _state = EntitlementState(
        isPremium: premium,
        features: premium
            ? PremiumFeatureFlag.values.toSet()
            : <PremiumFeatureFlag>{},
      );
    } catch (_) {
      _state = const EntitlementState(isPremium: false, features: <PremiumFeatureFlag>{});
    }
  }

  bool has(PremiumFeatureFlag flag) => _state.has(flag);
}
