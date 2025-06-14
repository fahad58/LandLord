import 'package:flutter/material.dart';
import 'property_model.dart';
import 'tenant_model.dart';
import 'add_tenant_screen.dart';

class DetailsScreen extends StatefulWidget {
  final Property property;
  final List<Tenant> tenants;
  final Function(Tenant) onTenantAdded;

  const DetailsScreen({
    super.key,
    required this.property,
    required this.tenants,
    required this.onTenantAdded,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late List<Tenant> assignedTenants;

  @override
  void initState() {
    super.initState();
    _filterTenants();
  }

  void _filterTenants() {
    assignedTenants = widget.tenants.where((t) {
      return t.assignedProperty.name == widget.property.name;
    }).toList();
  }

  Future<void> _addTenant() async {
    final newTenant = await Navigator.push<Tenant>(
      context,
      MaterialPageRoute(
        builder: (_) => AddTenantScreen(
          properties: [widget.property],
          onTenantAdded: (tenant) {
            Navigator.pop(context, tenant);
          },
        ),
      ),
    );

    if (newTenant != null) {
      widget.onTenantAdded(newTenant);
      setState(() {
        _filterTenants();
      });
    }
  }

  Widget _infoRow(String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: "$label1: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value1),
                ],
              ),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: "$label2: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 2),
            ...children
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),
        centerTitle: true,
        backgroundColor: const Color(0xff1e40af),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _sectionCard('Building Information', [
              _infoRow("Street", property.address, "Name", property.name),
              _infoRow("Type", property.type, "Rooms", property.rooms.toString()),
              _infoRow("Garden", property.hasGarden ? "Yes" : "No", "Parking", property.hasParking ? "Yes" : "No"),
              _infoRow("Rent", "\$${property.rent.toStringAsFixed(2)}", "Postal Code", property.postalCode),
            ]),
            _sectionCard('Assigned Tenants', [
              if (assignedTenants.isEmpty) ...[
                const Text('No tenants assigned yet.', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _addTenant,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Tenant'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff12265c),
                    foregroundColor: Colors.white,
                  ),
                ),
              ] else ...[
                for (var tenant in assignedTenants) ...[
                  const Divider(height: 20, thickness: 1),
                  Text(tenant.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  _infoRow("Contact", tenant.contact, "Nationality", tenant.nationality),
                  _infoRow("Married", tenant.isMarried ? "Yes" : "No", "Has Pets", tenant.hasPets ? "Yes" : "No"),
                  _infoRow("Rent", "\$${tenant.rentAmount.toStringAsFixed(2)}", "", ""),
                  if (property.type == 'Multi-Unit')
                    _infoRow("Level", tenant.level?.toString() ?? "-", "Unit", tenant.unit?.toString() ?? "-"),
                ],
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _addTenant,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Add Another Tenant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff12265c),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ]
            ]),
          ],
        ),
      ),
    );
  }
}
