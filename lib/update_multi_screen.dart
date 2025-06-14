import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'property_model.dart';

class UpdateMultiUnitScreen extends StatefulWidget {
  final Property property;

  const UpdateMultiUnitScreen({super.key, required this.property});

  @override
  State<UpdateMultiUnitScreen> createState() => _UpdateMultiUnitScreenState();
}

class _UpdateMultiUnitScreenState extends State<UpdateMultiUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, address, postalCode;
  late int levels, unitsPerLevel, rooms;
  late double rent;
  late bool hasGarden, hasParking;
  bool isSaving = false;

  // Styling
  final Color mainTextColor = HexColor("#4f4f4f");
  final Color secondaryTextColor = HexColor("#8d8d8d");
  final Color textFieldBackground = HexColor("#f0f3f1");
  final Color buttonBackground = HexColor("#fed8c3");

  InputDecoration inputDecoration({String? label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(fontSize: 18, color: secondaryTextColor),
      hintStyle: GoogleFonts.poppins(fontSize: 15, color: secondaryTextColor),
      fillColor: textFieldBackground,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      )),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 15, horizontal: 90),
      ),
      textStyle: WidgetStateProperty.all(GoogleFonts.poppins(fontSize: 15, color: mainTextColor)),
    );
  }

  @override
  void initState() {
    super.initState();
    name = widget.property.name;
    address = widget.property.address;
    postalCode = widget.property.postalCode;
    levels = widget.property.levels ?? 1;
    unitsPerLevel = widget.property.unitsPerLevel ?? 1;
    rooms = widget.property.rooms;
    rent = widget.property.rent;
    hasGarden = widget.property.hasGarden;
    hasParking = widget.property.hasParking;
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isSaving = true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final updatedProperty = Property(
          name: name,
          address: address,
          postalCode: postalCode,
          levels: levels,
          unitsPerLevel: unitsPerLevel,
          rooms: rooms,
          rent: rent,
          hasGarden: hasGarden,
          hasParking: hasParking,
          type: 'Multi-Unit (${levels}Lx${unitsPerLevel}U)',
        );

        Navigator.pop(context, updatedProperty);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Top gradient
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

          // Form card
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
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.black87,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Text(
                                "Update Multi-Unit",
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
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
                                  initialValue: name,
                                  decoration: inputDecoration(label: "Building Name"),
                                  onSaved: (val) => name = val ?? '',
                                  validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: address,
                                  decoration: inputDecoration(label: "Address"),
                                  onSaved: (val) => address = val ?? '',
                                  validator: (val) => val == null || val.isEmpty ? 'Enter address' : null,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: postalCode,
                                  decoration: inputDecoration(label: "Postal Code"),
                                  onSaved: (val) => postalCode = val ?? '',
                                  validator: (val) => val == null || val.isEmpty ? 'Enter postal code' : null,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: rooms.toString(),
                                  decoration: inputDecoration(label: "Rooms"),
                                  keyboardType: TextInputType.number,
                                  onSaved: (val) => rooms = int.tryParse(val ?? '') ?? 0,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: rent.toString(),
                                  decoration: inputDecoration(label: "Monthly Rent"),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onSaved: (val) => rent = double.tryParse(val ?? '') ?? 0.0,
                                ),
                                const SizedBox(height: 15),
                                DropdownButtonFormField<int>(
                                  value: levels,
                                  items: List.generate(5, (i) => i + 1)
                                      .map((val) => DropdownMenuItem(
                                            value: val,
                                            child: Text('$val Levels',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: mainTextColor)),
                                          ))
                                      .toList(),
                                  onChanged: (val) => setState(() => levels = val!),
                                  decoration: inputDecoration(label: 'Levels'),
                                  dropdownColor: textFieldBackground,
                                ),
                                const SizedBox(height: 15),
                                DropdownButtonFormField<int>(
                                  value: unitsPerLevel,
                                  items: List.generate(3, (i) => i + 1)
                                      .map((val) => DropdownMenuItem(
                                            value: val,
                                            child: Text('$val Units per Level',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: mainTextColor)),
                                          ))
                                      .toList(),
                                  onChanged: (val) => setState(() => unitsPerLevel = val!),
                                  decoration: inputDecoration(label: 'Units per Level'),
                                  dropdownColor: textFieldBackground,
                                ),
                                const SizedBox(height: 15),
                                SwitchListTile(
                                  title: Text("Garden", style: GoogleFonts.poppins(fontSize: 16)),
                                  value: hasGarden,
                                  onChanged: (val) => setState(() => hasGarden = val),
                                  activeColor: buttonBackground,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                SwitchListTile(
                                  title: Text("Parking", style: GoogleFonts.poppins(fontSize: 16)),
                                  value: hasParking,
                                  onChanged: (val) => setState(() => hasParking = val),
                                  activeColor: buttonBackground,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _saveForm,
                                    style: buttonStyle(),
                                    child: const Text("Save Changes"),
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
