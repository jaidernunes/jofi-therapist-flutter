import 'package:flutter/material.dart';

class AppTheme {
  static const Color iconGrey = Color(0xFF8E8E8E);
  static const Color standardOrange = Color(0xFFFF983D);
  static const Color offBlack = Color(0xFF595959);

  static const TextStyle navbarTextStyle = TextStyle(
      color: AppTheme.offBlack,
      fontSize: 14,
      fontFamily: 'Inter'
  );

  static const TextStyle appbarTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Inter'
  );

  // static final List<BoxShadow> standardBoxShadow = [
  //   BoxShadow(
      // color: Colors.grey.withOpacity(0.3),
      // spreadRadius: 2,
      // blurRadius: 5,
      // offset: const Offset(0, 3),
  //   ),
  // ];
  static final BorderRadius standardBorderRadius = BorderRadius.circular(20);

  static ThemeData buildThemeData() {
    return ThemeData(
      primarySwatch: Colors.blue,
      // example theme data
    );
  }
}
