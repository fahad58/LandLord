// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'property_model.dart';
import 'tenant_model.dart';

class AddTenantScreen extends StatefulWidget {
  final Property property;
  
  const AddTenantScreen({
    super.key,
    required this.property,
  });

  @override
  AddTenantScreenState createState() => AddTenantScreenState();
}

class AddTenantScreenState extends State<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _rentAmountController = TextEditingController();
  
  // Multi-unit specific controllers
  final _levelController = TextEditingController();
  final _unitController = TextEditingController();
  
  // Form values
  bool _isMarried = false;
  bool _hasPets = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _nationalityController.dispose();
    _rentAmountController.dispose();
    _levelController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final tenant = Tenant(
        name: _nameController.text,
        contact: _contactController.text,
        nationality: _nationalityController.text,
        isMarried: _isMarried,
        hasPets: _hasPets,
        rentAmount: double.parse(_rentAmountController.text),
        assignedProperty: widget.property,
        level: widget.property.isMultiUnit ? int.parse(_levelController.text) : null,
        unit: widget.property.isMultiUnit ? int.parse(_unitController.text) : null,
      );

      Navigator.pop(context, tenant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Add Tenant',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Property Info Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        widget.property.isSingleUnit ? Icons.home : Icons.apartment,
                        color: Colors.blue,
                      ),
                      title: Text(widget.property.name),
                      subtitle: Text(widget.property.address),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Personal Information
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tenant name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter contact number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nationalityController,
                      decoration: InputDecoration(
                        labelText: 'Nationality',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.public),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter nationality';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Rental Details
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rental Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _rentAmountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Monthly Rent',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter monthly rent';
                        }
                        return null;
                      },
                    ),
                    if (widget.property.isMultiUnit) ...[
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _levelController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: 'Level',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.layers),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                final level = int.tryParse(value);
                                if (level == null || level < 1 || 
                                    level > (widget.property.levels ?? 1)) {
                                  return 'Invalid level';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _unitController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: 'Unit',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.meeting_room),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                final unit = int.tryParse(value);
                                if (unit == null || unit < 1 || 
                                    unit > (widget.property.unitsPerLevel ?? 1)) {
                                  return 'Invalid unit';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Additional Information
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Married'),
                      value: _isMarried,
                      onChanged: (value) => setState(() => _isMarried = value),
                    ),
                    SwitchListTile(
                      title: Text('Has Pets'),
                      value: _hasPets,
                      onChanged: (value) => setState(() => _hasPets = value),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Add Tenant',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
