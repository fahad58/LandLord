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
                    colors: [Color(0xff12265c), Color(0xff12265c)],
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

class PropertyCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isSingle = property.type == 'Single House';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            Icon(
              isSingle ? Icons.house : Icons.apartment,
              size: 36,
              color: Colors.grey.shade700,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                property.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
