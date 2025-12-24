import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/login/delivery_login_screen.dart';
import 'package:petgo/features/auth/screens/register/delivery_register_screen.dart';
import 'package:petgo/features/delivery/screens/delivery_home_screen.dart';
import 'package:petgo/routes/auth_routes.dart';

class DeliveryRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AuthRoutes.deliveryLogin: (context) => const DeliveryLoginScreen(),
      AuthRoutes.deliveryRegister: (context) => const DeliveryRegisterScreen(),
      '/delivery-home': (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        final userName = args as String? ?? 'Usuário';
        
        return DeliveryHomeScreen(userName: userName);
      },
    };
  }
}
