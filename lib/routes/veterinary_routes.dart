import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/login/veterinary_login_screen.dart';
import 'package:petgo/features/auth/screens/register/veterinary_register_screen.dart';
import 'package:petgo/features/veterinary/screens/veterinary_home_screen.dart';

class VeterinaryRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/veterinary-login': (context) => const VeterinaryLoginScreen(),
      '/veterinary-register': (context) => const VeterinaryRegisterScreen(),
      '/veterinary-home': (context) => VeterinaryHomeScreen(
        userName: ModalRoute.of(context)!.settings.arguments as String,
      ),
    };
  }
}
