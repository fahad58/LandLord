// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'property_model.dart';
import 'single_unit_build_form.dart';
import 'multi_unit_build_form.dart';

class AddPropertyScreen extends StatelessWidget {
  const AddPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xff12265c);
    final Color cardColor = Colors.white;
    final Color textColor = HexColor("#333333");
    // Define the gradient colors
    final Color backgroundGradientStart = const Color(0xff12265c);
    final Color backgroundGradientEnd = const Color(0xff274690);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundGradientStart, backgroundGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              'Select Property Type',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Single Unit
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleHouseFormScreen()),
                          );
                          if (result != null && result is Property) {
                            Navigator.pop(context, result);
                          }
                        },
                        child: PropertyOptionCard(
                          imagePath: 'android/asset/animations/single_unit.png',
                          label: 'House',
                          textColor: textColor,
                          cardColor: cardColor,
                        ),
                      ),

                      const SizedBox(width: 40),

                      // Multi Unit
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiUnitFormScreen()),
                          );
                          if (result != null && result is Property) {
                            Navigator.pop(context, result);
                          }
                        },
                        child: PropertyOptionCard(
                          imagePath: 'android/asset/animations/Multi_unit.png',
                          label: 'Multi Unit',
                          textColor: textColor,
                          cardColor: cardColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class PropertyOptionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final Color textColor;
  final Color cardColor;

  const PropertyOptionCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.textColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
