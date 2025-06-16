import 'property_model.dart';

class Tenant {
  final String name;
  final String contact;
  final String nationality;
  final bool isMarried;
  final bool hasPets;
  final double rentAmount;
  final Property assignedProperty; // Store full property reference
  final int? level; // Only for multi-unit buildings
  final int? unit;

  Tenant({
    required this.name,
    required this.contact,
    required this.nationality,
    required this.isMarried,
    required this.hasPets,
    required this.rentAmount,
    required this.assignedProperty,
    this.level,
    this.unit,
  });

  String get propertyName => assignedProperty.name;
}
