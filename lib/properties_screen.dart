import 'package:flutter/material.dart';
import 'property_model.dart';

class My_Properties_Screen extends StatefulWidget {
  final List<Property> properties;

  const My_Properties_Screen({
    super.key,
    required this.properties,
  });

  @override
  // ignore: library_private_types_in_public_api
  _My_Properties_ScreenState createState() => _My_Properties_ScreenState();
}

class _My_Properties_ScreenState extends State<My_Properties_Screen> {
  String _searchQuery = '';
  String _filterType = 'All';
  
  List<Property> get filteredProperties {
    return widget.properties.where((property) {
      final matchesSearch = property.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          property.address.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterType == 'All' || 
                          property.type == _filterType;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Properties',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics_outlined, color: Colors.black),
            onPressed: () {
              //  Navigate to analytics dashboard
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search properties...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: 12),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        selected: _filterType == 'All',
                        label: Text('All'),
                        onSelected: (selected) {
                          setState(() => _filterType = 'All');
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        selected: _filterType == 'Single House',
                        label: Text('Single House'),
                        onSelected: (selected) {
                          setState(() => _filterType = 'Single House');
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        selected: _filterType == 'Multi-Unit',
                        label: Text('Multi-Unit'),
                        onSelected: (selected) {
                          setState(() => _filterType = 'Multi-Unit');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Property List
          Expanded(
            child: filteredProperties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No properties found',
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
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = filteredProperties[index];
                      return PropertyListItem(
                        property: property,
                        onTap: () {
                          //  Navigate to property details
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PropertyListItem extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyListItem({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image Section
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: AssetImage(
                    property.isSingleUnit
                        ? 'android/asset/animations/house.png'
                        : 'android/asset/animations/building.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Property Details Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        property.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${property.rent}/month',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${property.address}, ${property.postalCode}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 12),
                  // Property Features
                  Row(
                    children: [
                      _buildFeatureChip(
                        Icons.king_bed,
                        '${property.rooms} Rooms',
                      ),
                      SizedBox(width: 8),
                      if (property.hasParking)
                        _buildFeatureChip(
                          Icons.local_parking,
                          'Parking',
                        ),
                      SizedBox(width: 8),
                      if (property.hasGarden)
                        _buildFeatureChip(
                          Icons.park,
                          'Garden',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
