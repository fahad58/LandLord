// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:landlord/properties_screen.dart';
import 'multi_unit_build_form.dart';
import 'single_unit_build_form.dart';
import 'property_model.dart';
import 'tenant_screen.dart' as tenant_screen;
import 'tenant_model.dart';
import 'add_property_screen.dart';
import 'details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Property> _properties = [];
  final List<Tenant> _tenants = [];
  bool _showAddOptions = false;

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    if (index == 0) {
      page = My_Properties_Screen(properties: _properties);
    } else {
      page = tenant_screen.TenantsScreen(tenants: _tenants, properties: _properties);
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          child: child,
        ),
      ),
    );
  }

  Future<void> _handleAddProperty() async {
    final result = await Navigator.push<Property>(
      context,
      MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
    );

    if (result != null) {
      setState(() {
        _properties.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.home_work, color: Colors.blue),
            ),
            SizedBox(width: 12),
            Text('Property Manager'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              // Implement notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              accountName: Text('Property Manager'),
              accountEmail: Text('manager@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.dashboard_outlined),
              title: Text('Dashboard'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text('Properties'),
              onTap: () => _navigateTo(0),
            ),
            ListTile(
              leading: Icon(Icons.people_outline),
              title: Text('Tenants'),
              onTap: () => _navigateTo(1),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help & Support'),
              onTap: () {},
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      body: _properties.isEmpty
          ? _buildEmptyState()
          : _buildPropertyList(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateTo,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Tenants',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.home_work_outlined,
              size: 64,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Welcome to Property Manager',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Start by adding your first property',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _handleAddProperty,
            icon: Icon(Icons.add_home),
            label: Text('Add Your First Property'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _properties.length,
      itemBuilder: (context, index) {
        final property = _properties[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyDetailScreen(
                    property: property,
                    tenants: _tenants,
                    onTenantAdded: (tenant) {
                      setState(() {
                        _tenants.add(tenant);
                      });
                    },
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
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
                      Row(
                        children: [
                          _buildPropertyFeature(
                            Icons.bed,
                            '${property.rooms} Rooms',
                          ),
                          SizedBox(width: 16),
                          if (property.hasParking)
                            _buildPropertyFeature(
                              Icons.local_parking,
                              'Parking',
                            ),
                          if (property.hasParking && property.hasGarden)
                            SizedBox(width: 16),
                          if (property.hasGarden)
                            _buildPropertyFeature(
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
      },
    );
  }

  Widget _buildPropertyFeature(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showAddOptions) ...[
            FloatingActionButton.extended(
              heroTag: 'addSingleHouse',
              onPressed: () async {
                setState(() => _showAddOptions = false);
                final result = await Navigator.push<Property>(
                  context,
                  MaterialPageRoute(builder: (_) => SingleHouseFormScreen()),
                );

                if (result != null) {
                  setState(() {
                    _properties.add(result);
                  });
                }
              },
              icon: Icon(Icons.home),
              label: Text('Single House'),
              backgroundColor: Colors.blue,
            ),
            SizedBox(height: 16),
            FloatingActionButton.extended(
              heroTag: 'addMultiUnit',
              onPressed: () async {
                setState(() => _showAddOptions = false);
                final result = await Navigator.push<Property>(
                  context,
                  MaterialPageRoute(builder: (_) => MultiUnitFormScreen()),
                );

                if (result != null) {
                  setState(() {
                    _properties.add(result);
                  });
                }
              },
              icon: Icon(Icons.apartment),
              label: Text('Multi Unit'),
              backgroundColor: Colors.green,
            ),
            SizedBox(height: 16),
          ],
          FloatingActionButton(
            heroTag: 'mainFAB',
            onPressed: () {
              setState(() => _showAddOptions = !_showAddOptions);
            },
            backgroundColor: Colors.blue,
            child: Icon(_showAddOptions ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }
}
