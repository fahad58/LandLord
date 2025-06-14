import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tenant_model.dart';

class TenantsScreen extends StatefulWidget {
  final List<Tenant> tenants;

  const TenantsScreen({super.key, required this.tenants});

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  List<Tenant> get tenants => widget.tenants;

  void _editTenant(Tenant tenant) {
   
  }

  void _deleteTenant(Tenant tenant) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Tenant"),
        content: const Text("Are you sure you want to delete this tenant?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() => tenants.remove(tenant));
              Navigator.pop(ctx);
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
                      'My Tenants',
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

            // White container with list
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
                child: tenants.isEmpty
                    ? Center(
                        child: Text(
                          'No tenants added yet.',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: tenants.length,
                        itemBuilder: (context, index) {
                          final tenant = tenants[index];
                          return TenantCard(
                            tenant: tenant,
                            onEdit: () => _editTenant(tenant),
                            onDelete: () => _deleteTenant(tenant),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TenantCard extends StatelessWidget {
  final Tenant tenant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TenantCard({
    super.key,
    required this.tenant,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.person, size: 36, color: Colors.indigo),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tenant.name,
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
