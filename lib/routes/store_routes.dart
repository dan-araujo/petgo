import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/login/store_login_screen.dart';
import 'package:petgo/features/auth/screens/register/store_register_screen.dart';
import 'package:petgo/features/store/screens/store_home_screen.dart';
import 'package:petgo/routes/auth_routes.dart';

class StoreRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AuthRoutes.storeLogin: (context) => const StoreLoginScreen(),
      AuthRoutes.storeRegister: (context) => const StoreRegisterScreen(),
      '/store-home': (context) => StoreHomeScreen(
        userName: ModalRoute.of(context)!.settings.arguments as String,
      ),
    };
  }
}
