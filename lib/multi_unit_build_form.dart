import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'property_model.dart'; // Your Property class

class MultiUnitFormScreen extends StatefulWidget {
  const MultiUnitFormScreen({super.key});

  @override
  State<MultiUnitFormScreen> createState() => _MultiUnitFormScreenState();
}

class _MultiUnitFormScreenState extends State<MultiUnitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String buildingName = '';
  String address = '';
  String postalCode = '';
  int levels = 1;
  int unitsPerLevel = 1;
  int rooms = 0;
  double rent = 0.0;
  bool hasGarden = false;
  bool hasParking = false;
  bool isSaving = false;

  // Colors
  final Color mainTextColor = HexColor("#4f4f4f");
  final Color secondaryTextColor = HexColor("#8d8d8d");
  final Color textFieldBackground = HexColor("#f0f3f1");
  final Color buttonBackground = HexColor("#fed8c3");

  // Text styles
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

  void _saveMultiUnit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isSaving = true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(
          context,
          Property(
            name: buildingName,
            address: address,
            postalCode: postalCode,
            rooms: rooms,
            hasGarden: hasGarden,
            hasParking: hasParking,
            rent: rent,
            type: 'Multi-Unit (${levels}Lx${unitsPerLevel}U)',
          ),
        );
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background top 1/3
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height / 3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
            ),
          ),

          // White card container slightly moved up (from bottom)
          Positioned(
            top: size.height / 5, // moved up a bit
            left: 16,
            right: 16,
            bottom: 20, // some padding from bottom
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: isSaving
                  ? Center(
                      child: Lottie.asset(
                        'android/asset/animations/success.json',
                        width: 200,
                        height: 200,
                        repeat: false,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back arrow + Title row
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.black87,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Text(
                                "Multi-Unit Building Form",
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 48), // space to balance IconButton
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                TextFormField(
                                  decoration: inputDecoration(label: 'Building Name'),
                                  onSaved: (value) => buildingName = value ?? '',
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter building name' : null,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  decoration: inputDecoration(label: 'Address'),
                                  onSaved: (value) => address = value ?? '',
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter address' : null,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  decoration: inputDecoration(label: 'Postal Code'),
                                  onSaved: (value) => postalCode = value ?? '',
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter postal code' : null,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  decoration: inputDecoration(label: 'Rooms (Total)'),
                                  keyboardType: TextInputType.number,
                                  onSaved: (value) =>
                                      rooms = int.tryParse(value ?? '0') ?? 0,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  decoration: inputDecoration(label: 'Monthly Rent'),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                  onSaved: (value) =>
                                      rent = double.tryParse(value ?? '0.0') ?? 0.0,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<int>(
                                  value: levels,
                                  items: List.generate(5, (i) => i + 1)
                                      .map(
                                        (val) => DropdownMenuItem(
                                          value: val,
                                          child: Text(
                                            '$val Levels',
                                            style: labelTextStyle,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) => setState(() => levels = val!),
                                  decoration: inputDecoration(label: 'Levels'),
                                  dropdownColor: textFieldBackground,
                                ),
                                const SizedBox(height: 15),
                                DropdownButtonFormField<int>(
                                  value: unitsPerLevel,
                                  items: List.generate(3, (i) => i + 1)
                                      .map(
                                        (val) => DropdownMenuItem(
                                          value: val,
                                          child: Text(
                                            '$val Units per Level',
                                            style: labelTextStyle,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) => setState(() => unitsPerLevel = val!),
                                  decoration: inputDecoration(label: 'Units per Level'),
                                  dropdownColor: textFieldBackground,
                                ),
                                const SizedBox(height: 20),
                                SwitchListTile(
                                  title: Text("Garden", style: labelTextStyle),
                                  value: hasGarden,
                                  onChanged: (val) => setState(() => hasGarden = val),
                                  activeColor: buttonBackground,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                SwitchListTile(
                                  title: Text("Parking", style: labelTextStyle),
                                  value: hasParking,
                                  onChanged: (val) => setState(() => hasParking = val),
                                  activeColor: buttonBackground,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 25),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _saveMultiUnit,
                                    style: buttonStyle(),
                                    child: const Text("Save Building"),
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