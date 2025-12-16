import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/login/customer_login_screen.dart';
import 'package:petgo/features/auth/screens/register/customer_register_screen.dart';
import 'package:petgo/features/customer/screens/customer_home_screen.dart';

class CustomerRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/veterinary-login': (context) => const CustomerLoginScreen(),
      '/veterinary-register': (context) => const CustomerRegisterScreen(),
      '/veterinary-home': (context) => CustomerHomeScreen(
        userName: ModalRoute.of(context)!.settings.arguments as String,
      ),
    };
  }
}
