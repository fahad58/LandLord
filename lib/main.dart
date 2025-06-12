import 'package:flutter/material.dart';
import 'property_model.dart';
import 'properties_screen.dart';
import 'tenant_screen.dart';
import 'tenant_model.dart';
import 'add_property_screen.dart';
import 'add_tenant_screen.dart';

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
      MaterialPageRoute(
        builder: (_) => const AddPropertyScreen(),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Land Lord App'),
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
      body: Column(
        children: [
          // Gradient Welcome Section
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
            padding: const EdgeInsets.only(left: 36, top: 40, right: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Image(
                image: AssetImage('android/asset/animations/Land_Lord.png'),
                width: 500,
                height: 500,
              ),
            ),
          ),
        ],
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tenants',
          ),
        ],
      ),
    );
  }
}
