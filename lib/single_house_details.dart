import 'package:flutter/material.dart';
import 'property_model.dart'; // Update with actual model file

class SingleHouseDetailsPage extends StatelessWidget {
  final Property property;

  const SingleHouseDetailsPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(property.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Single House', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Address: ${property.address}', style: TextStyle(fontSize: 18)),
            Text('Postal Code: ${property.postalCode}', style: TextStyle(fontSize: 18)),
            Text('Rooms: ${property.rooms}', style: TextStyle(fontSize: 18)),
            Text('Garden: ${property.hasGarden ? "Yes" : "No"}', style: TextStyle(fontSize: 18)),
            Text('Parking: ${property.hasParking ? "Yes" : "No"}', style: TextStyle(fontSize: 18)),
            Text('Rent: ${property.rent.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}