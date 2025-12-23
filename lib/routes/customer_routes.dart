import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/login/customer_login_screen.dart';
import 'package:petgo/features/auth/screens/register/customer_register_screen.dart';
import 'package:petgo/features/customer/screens/customer_home_screen.dart';
import 'package:petgo/routes/auth_routes.dart';

class CustomerRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AuthRoutes.customerLogin: (context) => const CustomerLoginScreen(),
      AuthRoutes.customerRegister: (context) => const CustomerRegisterScreen(),
      '/customer-home': (context) => CustomerHomeScreen(
        userName: ModalRoute.of(context)!.settings.arguments as String,
      ),
    };
  }
}
