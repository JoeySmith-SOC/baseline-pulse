enum PremiumFeatureFlag {
  cloudSyncEnabled,
  intelligenceAdvanced,
  selectionModeAdvanced,
  backgroundTracking,
  elevationModeling,
  exportData,
}

class EntitlementState {
  const EntitlementState({
    required this.isPremium,
    required this.features,
  });

  final bool isPremium;
  final Set<PremiumFeatureFlag> features;

  bool has(PremiumFeatureFlag feature) => features.contains(feature);
}
