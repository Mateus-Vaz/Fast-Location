import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Marca
  static const primary = Color(0xFFE8590C);
  static const primaryDark = Color(0xFFB8420A);
  static const primaryOnDark = Color(0xFFFF8A4C);
  static const onPrimary = Colors.white;
  static const overlay = Color(0x99000000);

  // Tema claro
  static const lightBackground = Color(0xFFF8F6F4);
  static const lightSurface = Colors.white;
  static const lightField = Color(0xFFF1EDE9);
  static const lightBorder = Color(0xFFE5E1DC);

  // Tema escuro
  static const darkBackground = Color(0xFF14110E);
  static const darkSurface = Color(0xFF1E1A16);
  static const darkField = Color(0xFF2A241F);
  static const darkBorder = Color(0xFF3A332C);

  static List<Color> headerGradient(Brightness brightness) {
    return brightness == Brightness.dark
        ? const [Color(0xFF8A3206), Color(0xFF3D1704)]
        : const [Color(0xFFF76707), Color(0xFFB8420A)];
  }
}
