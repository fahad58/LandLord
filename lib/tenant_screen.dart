import 'package:flutter/material.dart';
import 'tenant_model.dart';

class TenantsScreen extends StatefulWidget {
  final List<Tenant> tenants;

  const TenantsScreen({super.key, required this.tenants});

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  void _editTenant(Tenant tenant) {
    // Placeholder for edit tenant logic
    // Navigate to edit screen or show a dialog
  }

  void _deleteTenant(Tenant tenant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this tenant?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.tenants.remove(tenant);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // Gradient background
            Positioned(
              child: Container(
                width: size.width,
                height: size.height / 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 60),
                    Text(
                      'Tenants',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // White list container
            Positioned(
              top: size.height / 4.5,
              left: 16,
              child: Container(
                width: size.width - 32,
                height: size.height / 1.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: widget.tenants.isEmpty
                    ? const Center(
                        child: Text(
                          'No tenants added yet.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemBuilder: (context, index) {
                          final tenant = widget.tenants[index];
                          return TenantCard(
                            tenant: tenant,
                            onEdit: () => _editTenant(tenant),
                            onDelete: () => _deleteTenant(tenant),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemCount: widget.tenants.length,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TenantCard extends StatefulWidget {
  final Tenant tenant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TenantCard({super.key, required this.tenant, required this.onEdit, required this.onDelete});

  @override
  State<TenantCard> createState() => _TenantCardState();
}

class _TenantCardState extends State<TenantCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final tenant = widget.tenant;
    final property = tenant.assignedProperty;
    final isMultiUnit = property.propertyType == PropertyType.multi;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          setState(() {
            expanded = !expanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 36),
                  const SizedBox(width: 8),
                  Text(
                    tenant.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: widget.onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 8),
                Text('Contact: ${tenant.contact}'),
                Text('Nationality: ${tenant.nationality}'),
                Text('Married: ${tenant.isMarried ? "Yes" : "No"}'),
                Text('Has Pets: ${tenant.hasPets ? "Yes" : "No"}'),
                Text('Property: ${property.name} (${isMultiUnit ? "Multi-Unit" : "Single"})'),
                if (isMultiUnit) Text('Level: ${tenant.level}, Unit: ${tenant.unit}'),
                Text('Rent: \$${tenant.rentAmount.toStringAsFixed(2)}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyType {
  static const single = 'Single';
  static const multi = 'Multi';
  final String propertyType;
  PropertyType(this.propertyType);
  @override
  String toString() => propertyType;
  static PropertyType fromString(String type) {
    return PropertyType(type);
  }
  static List<PropertyType> get values => [
    PropertyType(single),
    PropertyType(multi),
  ];
  static PropertyType? fromJson(String? json) {
    if (json == null) return null;
    return values.firstWhere((type) => type.propertyType == json, orElse: () => PropertyType(single));
  }
  String toJson() => propertyType;
}
