// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'property_model.dart';
import 'tenant_model.dart';
import 'add_tenant_screen.dart';
import 'tenant_details_screen.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;
  final List<Tenant> tenants;
  final Function(Tenant) onTenantAdded;

  const PropertyDetailScreen({
    super.key,
    required this.property,
    required this.tenants,
    required this.onTenantAdded,
  });

  @override
  PropertyDetailScreenState createState() => PropertyDetailScreenState();
}

class PropertyDetailScreenState extends State<PropertyDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Tenant> get propertyTenants => widget.tenants
      .where((tenant) => tenant.propertyName == widget.property.name)
      .toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Property Image
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.property.isSingleUnit
                        ? 'android/asset/animations/house.png'
                        : 'android/asset/animations/building.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(widget.property.name),
            ),
          ),
          // Property Details
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Quick Stats Cards
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Monthly Rent',
                        '\$${widget.property.rent}',
                        Icons.attach_money,
                        Colors.green,
                      ),
                      SizedBox(width: 16),
                      _buildStatCard(
                        'Units',
                        '${widget.property.unitCount}',
                        Icons.apartment,
                        Colors.blue,
                      ),
                      SizedBox(width: 16),
                      _buildStatCard(
                        'Occupancy',
                        '${(propertyTenants.length / widget.property.unitCount * 100).round()}%',
                        Icons.people,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
                // Tab Bar
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Details'),
                    Tab(text: 'Tenants'),
                    Tab(text: 'Analytics'),
                  ],
                ),
                // Tab Views
                SizedBox(
                  height: 500, // Fixed height for tab content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDetailsTab(),
                      _buildTenantsTab(),
                      _buildAnalyticsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<Tenant>(
            context,
            MaterialPageRoute(
              builder: (_) => AddTenantScreen(property: widget.property),
            ),
          );

          if (result != null) {
            widget.onTenantAdded(result);
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tenant added successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        icon: Icon(Icons.person_add),
        label: Text('Add Tenant'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Address', widget.property.address),
          _buildDetailItem('Postal Code', widget.property.postalCode),
          _buildDetailItem('Rooms', widget.property.rooms.toString()),
          _buildDetailItem('Type', widget.property.type),
          if (widget.property.isMultiUnit) ...[
            _buildDetailItem('Levels', widget.property.levels.toString()),
            _buildDetailItem('Units per Level', widget.property.unitsPerLevel.toString()),
          ],
          SizedBox(height: 16),
          Text(
            'Amenities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (widget.property.hasGarden)
                _buildAmenityChip('Garden', Icons.park),
              if (widget.property.hasParking)
                _buildAmenityChip('Parking', Icons.local_parking),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTenantsTab() {
    return propertyTenants.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No tenants yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: propertyTenants.length,
            itemBuilder: (context, index) {
              final tenant = propertyTenants[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TenantDetailsScreen(tenant: tenant),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: Text(
                                tenant.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tenant.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    tenant.contact,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '\$${tenant.rentAmount}/month',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            if (tenant.level != null)
                              _buildInfoChip(
                                Icons.apartment,
                                'Level ${tenant.level}',
                              ),
                            if (tenant.unit != null) ...[
                              SizedBox(width: 8),
                              _buildInfoChip(
                                Icons.door_front_door,
                                'Unit ${tenant.unit}',
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            if (tenant.hasPets)
                              _buildInfoChip(
                                Icons.pets,
                                'Has Pets',
                              ),
                            if (tenant.hasPets && tenant.isMarried)
                              SizedBox(width: 8),
                            if (tenant.isMarried)
                              _buildInfoChip(
                                Icons.favorite,
                                'Married',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildAnalyticsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildAnalyticCard(
            'Monthly Revenue',
            '\$${widget.property.rent * propertyTenants.length}',
            'From ${propertyTenants.length} occupied units',
            Icons.trending_up,
            Colors.green,
          ),
          SizedBox(height: 16),
          _buildAnalyticCard(
            'Vacancy Loss',
            '\$${widget.property.rent * (widget.property.unitCount - propertyTenants.length)}',
            'From ${widget.property.unitCount - propertyTenants.length} vacant units',
            Icons.trending_down,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildAnalyticCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label: Text(label),
      backgroundColor: Colors.grey[100],
    );
  }
}
