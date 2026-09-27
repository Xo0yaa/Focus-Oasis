/// Minimal plant model for the Home screen.
/// The full model (with isUnlocked, cost, isPlaced) lives in the Shop
/// and Inventory screens — see docs/DESIGN_SYSTEM_V3.pdf section I "What I
/// Save Concretely". This is just enough to grow a plant on Home as a
/// session progresses.
class PlantModel {
  final String id;
  final String name;

  const PlantModel({required this.id, required this.name});

  static const sampaguita = PlantModel(id: 'sampaguita', name: 'Sampaguita');
}

/// Growth stage 1 to 4, derived from how much of the current session
/// has been completed. Stage 4 (fully bloomed) is reached at 100%.
int stageForProgress(double progress) {
  if (progress >= 1.0) return 4;
  if (progress >= 0.66) return 3;
  if (progress >= 0.33) return 2;
  return 1;
}

String stageLabel(String plantName, int stage) {
  const names = ['Seedling', 'Sprout', 'Budding', 'Blooming'];
  final label = names[(stage - 1).clamp(0, 3)];
  return '$label, stage $stage of 4';
}
