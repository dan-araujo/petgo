import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/register/register_store_screen.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';

class StoreLoginScreen extends StatelessWidget {
  const StoreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginBaseScreen(
      title: 'Login do Parceiro',
      subtitle: 'Acesse sua conta para gerenciar pedidos e produtos.',
      imagePath: 'assets/images/store_login_cat.png',
      backgroundColor: const Color(0xFFFFF7F4),
      buttonColor: const Color(0xFFFF8C8C),
      onRegisterTap: () {
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => const RegisterStoreScreen()),
        );
      },
      onLogin: (email, password) async {
        await Future.delayed(const Duration(seconds: 1));
      },
    );
  }
}
