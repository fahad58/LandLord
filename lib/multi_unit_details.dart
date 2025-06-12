import 'package:flutter/material.dart';
import 'property_model.dart';

class MultiUnitBuildingDetailsPage extends StatelessWidget {
  final Property property;

  const MultiUnitBuildingDetailsPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(property.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailTile('Building Name', property.name),
            _buildDetailTile('Address', property.address),
            _buildDetailTile('Postal Code', property.postalCode),
            _buildDetailTile('Levels', property.levels.toString()),
            _buildDetailTile('Units per Level', property.unitsPerLevel.toString()),
            _buildDetailTile('Rooms', property.rooms.toString()),
            _buildDetailTile('Rent', '${property.rent}'),
            _buildDetailTile('Has Garden', property.hasGarden ? 'Yes' : 'No'),
            _buildDetailTile('Has Parking', property.hasParking ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
        leading: const Icon(Icons.info_outline),
      ),
    );
  }
}