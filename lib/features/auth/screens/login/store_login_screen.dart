import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/register/store_register_screen.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';
import 'package:petgo/features/store/screens/store_home_screen.dart';

class StoreLoginScreen extends StatelessWidget {
  const StoreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return LoginBaseScreen(
      title: 'Login do Parceiro',
      subtitle: 'Acesse sua conta para gerenciar pedidos e produtos.',
      imagePath: 'assets/images/login_store.png',
      backgroundColor: const Color(0xFFFFF7F4),
      buttonColor: const Color(0xFFEC5050),
      onRegisterTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StoreRegisterScreen()),
        );
      },
      onLogin: (email, password) async {
        final result = await authService.loginStore(email, password);

        if(!context.mounted) return;

        await TokenService.saveToken(result.accessToken);
        await TokenService.saveUser(
          result.user.id,
          result.user.name,
          result.user.email,
        );

        if(!context.mounted) return;
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StoreHomeScreen(userName: result.user.name),
          ),
        );
      },
    );
  }
}
