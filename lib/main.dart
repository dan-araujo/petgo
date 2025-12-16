import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/home/home_screen.dart';
import 'package:petgo/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      title: 'PetGo!',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomeScreen(),
      routes: AppRoutes.getRoutes(),
    );
  }
}
