import 'package:flutter/material.dart';
import 'package:flutter_compass_app/constants/app_colors.dart';
import 'package:flutter_compass_app/screens/compass_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Compass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.primaryColor,
      ),
      home: const CompassScreen(),
    );
  }
}
