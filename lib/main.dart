import 'package:flutter/material.dart';
import 'property_model.dart';
import 'properties_screen.dart';
import 'tenant_screen.dart';
import 'tenant_model.dart';
import 'add_property_screen.dart';
import 'add_tenant_screen.dart';
import 'details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landlord App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
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

bool _showAddOptions = false;

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Property> _properties = [];
  final List<Tenant> _tenants = [];

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    if (index == 0) {
      page = My_Properties_Screen(properties: _properties);
    } else {
      page = TenantsScreen(tenants: _tenants);
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

  void _handleAddProperty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
    );

    if (result != null && result is Property) {
      setState(() {
        _properties.add(result);
      });
    }
  }

  void _handleAddTenant() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTenantScreen(
          properties: _properties,
          onTenantAdded: (tenant) {
            setState(() {
              _tenants.add(tenant);
            });
          },
        ),
      ),
    );

    if (result != null && result is Tenant) {
      setState(() {
        _tenants.add(result);
      });
    }
  }

  void _handleTenantAdded(Tenant tenant) {
    setState(() {
      _tenants.add(tenant);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Land Lord'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 60),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: _properties.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to Your Property Portfolio',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Click the button below to add your first property',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _handleAddProperty,
                      icon: const Icon(Icons.add_home),
                      label: const Text('Add Your First Property'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: _properties.length,
                itemBuilder: (context, index) {
                  final property = _properties[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(
                            property: property,
                            tenants: _tenants,
                            onTenantAdded: _handleTenantAdded,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xff1e40af),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                property.isMultiUnit ? Icons.apartment : Icons.house,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    property.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      property.unitCount == 1
                                          ? '1 Unit'
                                          : '${property.unitCount} Units',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0, right: 16.0),
        child: SizedBox(
          width: 250,
          height: 160,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: _showAddOptions ? 100 : 40,
                right: _showAddOptions ? 80 : 0,
                child: AnimatedOpacity(
                  opacity: _showAddOptions ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: 160,
                    child: FloatingActionButton.extended(
                      heroTag: 'addProperty',
                      onPressed: () {
                        setState(() => _showAddOptions = false);
                        _handleAddProperty();
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Add Property'),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: _showAddOptions ? 20 : 40,
                right: _showAddOptions ? 80 : 0,
                child: AnimatedOpacity(
                  opacity: _showAddOptions ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: 160,
                    child: FloatingActionButton.extended(
                      heroTag: 'addTenant',
                      onPressed: () {
                        setState(() => _showAddOptions = false);
                        _handleAddTenant();
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add Tenant'),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  heroTag: 'mainFAB',
                  onPressed: () {
                    setState(() => _showAddOptions = !_showAddOptions);
                  },
                  child: Icon(_showAddOptions ? Icons.close : Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateTo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Properties'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Tenants'),
        ],
      ),
    );
  }
}
