import 'package:flutter/material.dart';
import 'package:imgcompare/features/compare_page.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
       primarySwatch: Colors.red,
       scaffoldBackgroundColor: Colors.black,
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
           backgroundColor: Colors.grey[900],
           foregroundColor: Colors.white,
         ),
       ),
       textTheme: const TextTheme(
         bodyMedium: TextStyle(color: Colors.white), // Default text color
       ),
     ),
     home: const ComparePage(),
   );
 }
}

