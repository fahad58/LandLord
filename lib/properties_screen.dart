import 'package:flutter/material.dart';
import 'property_model.dart';
import 'updatepropertyscreen.dart';
import 'update_multi_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class My_Properties_Screen extends StatefulWidget {
  final List<Property> properties;

  const My_Properties_Screen({super.key, required this.properties});

  @override
  State<My_Properties_Screen> createState() => _My_Properties_ScreenState();
}

class _My_Properties_ScreenState extends State<My_Properties_Screen> {
  List<Property> get properties => widget.properties;
//
  void _deleteProperty(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Property"),
        content: const Text("Are you sure you want to delete this property?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() => properties.removeAt(index));
              Navigator.pop(ctx);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

void _editProperty(int index) async {
  final property = properties[index];
  dynamic updated;
  if (property.type == 'Single House') {
    updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateSingleHouseFormScreen(property: property),
      ),
    );
  } else {
    updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateMultiUnitScreen(property: property),
      ),
    );
  }
  if (updated != null && updated is Property) {
    setState(() => properties[index] = updated);
  }
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
            // Background gradient
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
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      'My Properties',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // White card container
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
                child: properties.isEmpty
                    ? Center(
                        child: Text(
                          'No properties added yet.',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          return PropertyCard(
                            property: properties[index],
                            onEdit: () => _editProperty(index),
                            onDelete: () => _deleteProperty(index),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final prop = widget.property;
    final isSingle = prop.type == 'Single House';
    final isMultiUnit = prop.type == 'Multi-Unit';
    

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => setState(() => expanded = !expanded),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isSingle ? Icons.house : Icons.apartment,
                      size: 36,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                Expanded(
                      child: Text(
                        prop.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: widget.onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: widget.onDelete,
                    ),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey,
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: 8),
                  buildDetail('name', prop.name),
                  buildDetail('Address', prop.address),
                  buildDetail('Postal Code', prop.postalCode),
                  buildDetail('Rooms', prop.rooms.toString()),
                  buildDetail('Garden', prop.hasGarden ? 'Yes' : 'No'),
                  buildDetail('Parking', prop.hasParking ? 'Yes' : 'No'),
                  buildDetail('Rent', '${prop.rent}'),
                  buildDetail('Type', prop.type),
                  
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '$label: $value',
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }
  
}