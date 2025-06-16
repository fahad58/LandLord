class Property {
  final String name;
  final String address;
  final String postalCode;
  final int rooms;
  final bool hasGarden;
  final bool hasParking;
  final double rent;
  final String type; // "Single House" or "Multi-Unit"
  final int? levels;       // for Multi-Unit buildings, nullable
  final int? unitsPerLevel; // for Multi-Unit buildings, nullable

  Property({
    required this.name,
    required this.address,
    required this.postalCode,
    required this.rooms,
    required this.hasGarden,
    required this.hasParking,
    required this.rent,
    required this.type,
    this.levels,
    this.unitsPerLevel,
  });
bool get isSingleUnit => normalizedType == PropertyType.singleHouse.toLowerCase();
  /// Returns total unit count: for multi-unit buildings levels * unitsPerLevel, otherwise 1
  int get unitCount {
    if (isMultiUnit) {
      // If levels or unitsPerLevel are null, assume at least 1
      final totalLevels = levels ?? 1;
      final totalUnitsPerLevel = unitsPerLevel ?? 1;
      return totalLevels * totalUnitsPerLevel;
    } else {
      return 1;
    }
  }

  /// Normalize type string with trimming & lowercasing (useful if input is inconsistent)
  String get normalizedType => type.trim().toLowerCase();

  /// Helper boolean to identify multi-unit property
  bool get isMultiUnit => normalizedType == PropertyType.multiUnit.toLowerCase();

  /// Helper boolean for single house property
  bool get isSingleHouse => normalizedType == PropertyType.singleHouse.toLowerCase();

  get propertyType => null;
}

class PropertyType {
  static const singleHouse = "Single House";
  static const multiUnit = "Multi-Unit";
}
