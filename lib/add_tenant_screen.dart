import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'property_model.dart';
import 'tenant_model.dart';

class AddTenantScreen extends StatefulWidget {
  final List<Property> properties;
  final Function(Tenant) onTenantAdded;

  const AddTenantScreen({
    super.key,
    required this.properties,
    required this.onTenantAdded,
  });

  @override
  AddTenantScreenState createState() => AddTenantScreenState();
}

class AddTenantScreenState extends State<AddTenantScreen> {
  Property? selectedProperty;
  int? selectedLevel;
  int? selectedUnit;

  final _formKey = GlobalKey<FormState>();

  String tenantName = '';
  String tenantContact = '';
  String nationality = '';
  bool isMarried = false;
  bool hasPets = false;
  double rentAmount = 0.0;

  final Color mainTextColor = HexColor("#4f4f4f");
  final Color secondaryTextColor = HexColor("#8d8d8d");
  final Color textFieldBackground = HexColor("#f0f3f1");
  final Color buttonBackground = HexColor("#fed8c3");

  late final TextStyle labelTextStyle = GoogleFonts.poppins(
    fontSize: 18,
    color: secondaryTextColor,
  );

  late final TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 15,
    color: mainTextColor,
  );

  InputDecoration inputDecoration({String? label, String? hint}) {
    return InputDecoration(
      labelText: label,
      labelStyle: labelTextStyle,
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: secondaryTextColor,
      ),
      fillColor: textFieldBackground,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(buttonBackground),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 15, horizontal: 90),
      ),
      textStyle: WidgetStateProperty.all(buttonTextStyle),
    );
  }

  List<int> get levelsList =>
      List.generate(selectedProperty?.levels ?? 0, (i) => i + 1);

  List<int> get unitsList =>
      List.generate(selectedProperty?.unitsPerLevel ?? 0, (i) => i + 1);

  final Map<String, Set<String>> occupiedUnits = {};

  bool isUnitOccupied(int level, int unit) {
    String key = '${selectedProperty?.name}_$level';
    return occupiedUnits[key]?.contains(unit.toString()) ?? false;
  }

  void _saveTenant() {
    if (_formKey.currentState!.validate() && selectedProperty != null) {
      _formKey.currentState!.save();

      Tenant newTenant = Tenant(
        name: tenantName,
        contact: tenantContact,
        assignedProperty: selectedProperty!,
        level: selectedProperty!.type == 'Multi-Unit' ? selectedLevel : null,
        unit: selectedProperty!.type == 'Multi-Unit' ? selectedUnit : null,
        nationality: nationality,
        isMarried: isMarried,
        hasPets: hasPets,
        rentAmount: rentAmount,
      );

      if (selectedProperty!.type == 'Multi-Unit') {
        String key = '${selectedProperty!.name}_$selectedLevel';
        occupiedUnits.putIfAbsent(key, () => {});
        occupiedUnits[key]!.add(selectedUnit.toString());
      }

      widget.onTenantAdded(newTenant);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height / 3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff12265c), Color(0xff12265c)],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height / 5,
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.black87,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          "Tenant Form",
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          DropdownButtonFormField<Property>(
                            decoration: inputDecoration(label: 'Select Property'),
                            items: widget.properties
                                .map((p) => DropdownMenuItem(
                                      value: p,
                                      child: Text('${p.name} (${p.type})'),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedProperty = val;
                                selectedLevel = null;
                                selectedUnit = null;
                              });
                            },
                            validator: (val) => val == null
                                ? 'Please select a property'
                                : null,
                          ),
                          if (selectedProperty?.type == 'Multi-Unit') ...[
                            const SizedBox(height: 15),
                            DropdownButtonFormField<int>(
                              decoration: inputDecoration(label: 'Select Level'),
                              items: levelsList
                                  .map((lvl) => DropdownMenuItem(
                                        value: lvl,
                                        child: Text('Level $lvl'),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedLevel = val;
                                  selectedUnit = null;
                                });
                              },
                              validator: (val) => val == null
                                  ? 'Please select a level'
                                  : null,
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<int>(
                              decoration: inputDecoration(label: 'Select Unit'),
                              items: unitsList
                                  .map((unit) {
                                    bool occupied = selectedLevel != null &&
                                        isUnitOccupied(selectedLevel!, unit);
                                    return DropdownMenuItem(
                                      value: occupied ? null : unit,
                                      enabled: !occupied,
                                      child: Text(
                                        'Unit $unit ${occupied ? '(Occupied)' : '(Available)'}',
                                        style: TextStyle(
                                          color: occupied
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                              onChanged: (val) => setState(() => selectedUnit = val),
                              validator: (val) => val == null
                                  ? 'Please select a unit'
                                  : null,
                            ),
                          ],
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: inputDecoration(label: 'Tenant Name'),
                            onSaved: (val) => tenantName = val ?? '',
                            validator: (val) =>
                                val == null || val.isEmpty ? 'Enter tenant name' : null,
                            cursorColor: mainTextColor,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: inputDecoration(label: 'Contact Info'),
                            onSaved: (val) => tenantContact = val ?? '',
                            validator: (val) =>
                                val == null || val.isEmpty ? 'Enter contact info' : null,
                            cursorColor: mainTextColor,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: inputDecoration(label: 'Nationality'),
                            onSaved: (val) => nationality = val ?? '',
                            cursorColor: mainTextColor,
                          ),
                          SwitchListTile(
                            title: Text("Is Married", style: labelTextStyle),
                            value: isMarried,
                            onChanged: (val) => setState(() => isMarried = val),
                            activeColor: buttonBackground,
                            contentPadding: EdgeInsets.zero,
                          ),
                          SwitchListTile(
                            title: Text("Has Pets", style: labelTextStyle),
                            value: hasPets,
                            onChanged: (val) => setState(() => hasPets = val),
                            activeColor: buttonBackground,
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: inputDecoration(label: 'Rent Amount'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onSaved: (val) =>
                                rentAmount = double.tryParse(val ?? '') ?? 0.0,
                            validator: (val) =>
                                val == null || val.isEmpty ? 'Enter rent amount' : null,
                            cursorColor: mainTextColor,
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: ElevatedButton(
                              onPressed: _saveTenant,
                              style: buttonStyle(),
                              child: const Text("Save Tenant"),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
