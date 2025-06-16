// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'tenant_model.dart';
import 'property_model.dart';
import 'add_tenant_screen.dart';

class TenantsScreen extends StatefulWidget {
  final List<Tenant> tenants;
  final List<Property> properties;

  const TenantsScreen({
    super.key,
    required this.tenants,
    required this.properties,
  });

  @override
  TenantsScreenState createState() => TenantsScreenState();
}

class TenantsScreenState extends State<TenantsScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<Tenant> get filteredTenants {
    return widget.tenants.where((tenant) {
      final matchesSearch = tenant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          tenant.contact.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterStatus == 'All' ||
                          (_filterStatus == 'With Pets' && tenant.hasPets) ||
                          (_filterStatus == 'Married' && tenant.isMarried);
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
          'Tenants',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.sort, color: Colors.black),
            onPressed: () {
              //  Implement sorting options
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
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search tenants...',
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        selected: _filterStatus == 'All',
                        label: Text('All'),
                        onSelected: (selected) {
                          setState(() => _filterStatus = 'All');
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        selected: _filterStatus == 'With Pets',
                        label: Text('With Pets'),
                        onSelected: (selected) {
                          setState(() => _filterStatus = 'With Pets');
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        selected: _filterStatus == 'Married',
                        label: Text('Married'),
                        onSelected: (selected) {
                          setState(() => _filterStatus = 'Married');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tenant List
          Expanded(
            child: filteredTenants.isEmpty
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
                          'No tenants found',
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
                    itemCount: filteredTenants.length,
                    itemBuilder: (context, index) {
                      final tenant = filteredTenants[index];
                      return Dismissible(
                        key: Key(tenant.name),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Tenant'),
                                content: Text(
                                  'Are you sure you want to delete ${tenant.name}?'
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => 
                                      Navigator.of(context).pop(false),
                                    child: Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () => 
                                      Navigator.of(context).pop(true),
                                    child: Text(
                                      'DELETE',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          setState(() {
                            widget.tenants.removeWhere(
                              (t) => t.name == tenant.name
                            );
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${tenant.name} deleted'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              //  Navigate to tenant details
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
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
                                            Row(
                                              children: [
                                                Text(
                                                  tenant.name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Colors.blue,
                                                  ),
                                                  onPressed: () async {
                                                    final result = await Navigator.push<Tenant>(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => AddTenantScreen(
                                                          property: tenant.assignedProperty,
                                                         // existingTenant: tenant,
                                                        ),
                                                      ),
                                                    );

                                                    if (result != null) {
                                                      setState(() {
                                                        final index = widget.tenants.indexWhere(
                                                          (t) => t.name == tenant.name
                                                        );
                                                        if (index != -1) {
                                                          widget.tenants[index] = result;
                                                        }
                                                      });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Tenant updated successfully'),
                                                          backgroundColor: Colors.green,
                                                          behavior: SnackBarBehavior.floating,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                  tooltip: 'Edit Tenant',
                                                ),
                                              ],
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
                                      _buildInfoChip(
                                        Icons.home,
                                        tenant.propertyName,
                                      ),
                                      if (tenant.level != null) ...[
                                        SizedBox(width: 8),
                                        _buildInfoChip(
                                          Icons.apartment,
                                          'Level ${tenant.level}',
                                        ),
                                      ],
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.properties.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please add a property first'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          final result = await Navigator.push<Tenant>(
            context,
            MaterialPageRoute(
              builder: (_) => AddTenantScreen(
                property: widget.properties.first,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              widget.tenants.add(result);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tenant added successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
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
