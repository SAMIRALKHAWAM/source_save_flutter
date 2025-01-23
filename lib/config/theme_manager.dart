import 'package:flutter/material.dart';

abstract class ThemeManager {
  // ثيم الضوء
  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 98, 93, 241), // لون شريط التطبيق
    ),
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 94, 42, 157), // أزرق داكن
      onPrimary: Colors.white, // نص فوق اللون الرئيسي
      secondary: Color.fromARGB(255, 49, 19, 78), // موف فاتح
    ),
    primaryColor: Colors.grey.shade300, // لون رئيسي رمادي فاتح مائل للصفار
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 50,
        color: Color.fromARGB(255, 94, 42, 157),
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 80, 90, 85),
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
      ),
      labelLarge: TextStyle(
        color: Color.fromARGB(255, 49, 19, 78), // لون نص الأزرار إلى موف
      ),
    ),
    scaffoldBackgroundColor: Colors.grey.shade100, // لون الخلفية إلى رمادي فاتح مائل للصفار
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 49, 19, 78), // لون الداور إلى موف
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.white, // لون الأزرار إلى الأبيض
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade200, // اللون الرمادي الفاتح للكارد (أفتح من الخلفية)
    ),
  );

  // ثيم الظلام
  static ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 115, 98, 151), // لون شريط التطبيق موف
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 207, 142, 211), // لون داكن للزر الرئيسي
      onPrimary: Colors.white, // نص فوق اللون الرئيسي
      secondary: Color.fromARGB(255, 7, 120, 232), // أزرق
    ),
    primaryColor: Color.fromARGB(255, 115, 98, 151), //موف // موف داكن
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 50,
        color: Color.fromARGB(255, 207, 142, 211),
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        fontSize: 12,
        color: Colors.white, // نص باللون الأبيض
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
      ),
      labelLarge: TextStyle(
        color: Colors.white, // لون نص الأزرار إلى الأبيض
      ),
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 109, 107, 107), // لون الخلفية إلى رمادي غامق
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 93, 64, 120), // لون الداور إلى موف
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade700, // اللون الرمادي الغامق للكارد (أفتح من الخلفية)
    ),
  );
}
