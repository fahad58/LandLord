// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'property_model.dart';

class UpdateSingleHouseFormScreen extends StatefulWidget {
  final Property property;

  const UpdateSingleHouseFormScreen({super.key, required this.property});

  @override
  State<UpdateSingleHouseFormScreen> createState() => _UpdateSingleHouseFormScreenState();
}

class _UpdateSingleHouseFormScreenState extends State<UpdateSingleHouseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String propertyName;
  late String address;
  late String postalCode;
  late int rooms;
  late bool hasGarden;
  late bool hasParking;
  late double rent;
  bool isSaving = false;

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

  @override
  void initState() {
    super.initState();
    propertyName = widget.property.name;
    address = widget.property.address;
    postalCode = widget.property.postalCode;
    rooms = widget.property.rooms;
    hasGarden = widget.property.hasGarden;
    hasParking = widget.property.hasParking;
    rent = widget.property.rent;
  }

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
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 15, horizontal: 90),
      ),
      textStyle: WidgetStateProperty.all(buttonTextStyle),
    );
  }

  void _updateProperty() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isSaving = true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(
          context,
          Property(
            name: propertyName,
            address: address,
            postalCode: postalCode,
            rooms: rooms,
            hasGarden: hasGarden,
            hasParking: hasParking,
            rent: rent,
            type: 'Single House',
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
          // Gradient background
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

          // White form card
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
                        // Header
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.black87,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Text(
                                "Update Single House",
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
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
                                TextFormField(
                                  initialValue: propertyName,
                                  decoration:
                                      inputDecoration(label: 'Property Name'),
                                  onSaved: (value) =>
                                      propertyName = value ?? '',
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter property name' : null,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: address,
                                  decoration: inputDecoration(label: 'Address'),
                                  onSaved: (value) => address = value ?? '',
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter address' : null,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: postalCode,
                                  decoration:
                                      inputDecoration(label: 'Postal Code'),
                                  onSaved: (value) => postalCode = value ?? '',
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter postal code' : null,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: rooms.toString(),
                                  decoration: inputDecoration(label: 'Rooms'),
                                  keyboardType: TextInputType.number,
                                  onSaved: (value) =>
                                      rooms = int.tryParse(value ?? '') ?? 0,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter number of rooms' : null,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 20),
                                SwitchListTile(
                                  title: Text("Has Garden", style: labelTextStyle),
                                  value: hasGarden,
                                  onChanged: (val) =>
                                      setState(() => hasGarden = val),
                                  activeColor: buttonBackground,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                SwitchListTile(
                                  title: Text("Has Parking", style: labelTextStyle),
                                  value: hasParking,
                                  onChanged: (val) =>
                                      setState(() => hasParking = val),
                                  activeColor: buttonBackground,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: rent.toString(),
                                  decoration: inputDecoration(label: 'Rent'),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                  onSaved: (value) =>
                                      rent = double.tryParse(value ?? '') ?? 0.0,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter rent amount' : null,
                                  cursorColor: mainTextColor,
                                ),
                                const SizedBox(height: 25),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _updateProperty,
                                    style: buttonStyle(),
                                    child: const Text("Update Property"),
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
