class Property {
  final String name;
  final String address;
  final String postalCode;
  final int rooms;
  final bool hasGarden;
  final bool hasParking;
  final double rent;
  final String type; // "Single House" or "Multi-Unit"
  final int? levels; // for Multi-Unit buildings
  final int? unitsPerLevel; // for Multi-Unit buildings

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

  get propertyType => null;
}