/// PlantModel(id, name, isUnlocked, cost, isPlaced) — see Proposal V2
/// section IV "What I Save Concretely" and Design System v3 section I.
/// Stored as a JSON string list under the 'user_inventory' key.
class PlantModel {
  final String id;
  final String name;
  final String rarity; // 'Common', 'Rare', 'Legendary'
  final int cost;
  final bool isUnlocked;
  final bool isPlaced;
  final bool isNew;

  const PlantModel({
    required this.id,
    required this.name,
    required this.rarity,
    required this.cost,
    this.isUnlocked = false,
    this.isPlaced = false,
    this.isNew = false,
  });

  PlantModel copyWith({bool? isUnlocked, bool? isPlaced, bool? isNew}) {
    return PlantModel(
      id: id,
      name: name,
      rarity: rarity,
      cost: cost,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isPlaced: isPlaced ?? this.isPlaced,
      isNew: isNew ?? this.isNew,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rarity': rarity,
        'cost': cost,
        'isUnlocked': isUnlocked,
        'isPlaced': isPlaced,
        'isNew': isNew,
      };

  factory PlantModel.fromJson(Map<String, dynamic> json) => PlantModel(
        id: json['id'] as String,
        name: json['name'] as String,
        rarity: json['rarity'] as String? ?? 'Common',
        cost: json['cost'] as int? ?? 0,
        isUnlocked: json['isUnlocked'] as bool? ?? false,
        isPlaced: json['isPlaced'] as bool? ?? false,
        isNew: json['isNew'] as bool? ?? false,
      );

  /// The full catalog, in shop display order. Every plant in the game has
  /// a row here, whether owned or not — matches the proposal's "every
  /// plant in the shop catalog has a record" note. Sampaguita starts
  /// unlocked and placed, since it's the plant shown on Home before the
  /// player has bought anything.
  static List<PlantModel> starterCatalog() => const [
        PlantModel(id: 'sampaguita', name: 'Sampaguita', rarity: 'Common', cost: 0, isUnlocked: true, isPlaced: true),
        PlantModel(id: 'sunflower', name: 'Sunflower', rarity: 'Common', cost: 0, isUnlocked: true),
        PlantModel(id: 'rose', name: 'Rose', rarity: 'Common', cost: 100),
        PlantModel(id: 'lavender', name: 'Lavender', rarity: 'Common', cost: 150),
        PlantModel(id: 'tulip', name: 'Tulip', rarity: 'Rare', cost: 200),
        PlantModel(id: 'bonsai', name: 'Bonsai', rarity: 'Legendary', cost: 500),
      ];
}

/// Growth stage 1 to 4, derived from how much of the current session has
/// been completed. Stage 4 (fully grown) is reached at 100%.
int stageForProgress(double progress) {
  if (progress >= 1.0) return 4;
  if (progress >= 0.66) return 3;
  if (progress >= 0.33) return 2;
  return 1;
}

String stageLabel(int stage) {
  const names = ['Seedling', 'Sprout', 'Budding', 'Blooming'];
  return '${names[(stage - 1).clamp(0, 3)]}, stage $stage of 4';
}
