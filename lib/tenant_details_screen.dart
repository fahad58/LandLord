import 'package:flutter/material.dart';
import 'tenant_model.dart';

class TenantDetailsScreen extends StatelessWidget {
  final Tenant tenant;

  const TenantDetailsScreen({
    super.key,
    required this.tenant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue, Colors.blue.shade800],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          tenant.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        tenant.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Property Details',
                    [
                      _buildDetailRow('Property', tenant.propertyName),
                      if (tenant.level != null)
                        _buildDetailRow('Level', 'Level ${tenant.level}'),
                      if (tenant.unit != null)
                        _buildDetailRow('Unit', 'Unit ${tenant.unit}'),
                      _buildDetailRow('Rent', '\$${tenant.rentAmount}/month'),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildSection(
                    'Contact Information',
                    [
                      _buildDetailRow('Phone', tenant.contact),
                      // Add more contact details if available in your tenant model
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildSection(
                    'Personal Information',
                    [
                      _buildDetailRow('Marital Status', 
                        tenant.isMarried ? 'Married' : 'Single'),
                      _buildDetailRow('Pets', 
                        tenant.hasPets ? 'Has Pets' : 'No Pets'),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildSection(
                    'Lease Information',
                    [
                      // Add lease details if available in your tenant model
                      _buildDetailRow('Status', 'Active'),
                      _buildDetailRow('Payment Status', 'Up to date'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to edit tenant screen
          // You can reuse your AddTenantScreen here
        },
        icon: Icon(Icons.edit),
        label: Text('Edit Details'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
