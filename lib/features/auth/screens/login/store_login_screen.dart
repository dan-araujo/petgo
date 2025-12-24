import 'package:flutter/material.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';
import 'package:petgo/routes/auth_routes.dart';

class StoreLoginScreen extends StatelessWidget {
  const StoreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return LoginBaseScreen(
      title: 'Login do Parceiro',
      subtitle: 'Acesse sua conta para gerenciar pedidos e produtos.',
      imagePath: 'assets/images/login/store_clerk_smile.png',
      imageHeight: 230.0,
      imageWithBorderRadius: true,
      backgroundColor: const Color(0xFFFFF7F4),
      buttonColor: const Color(0xFFEC5050),
      onRegisterTap: () {
        Navigator.pushNamed(context, '/store-register');
      },
      onLogin: (email, password) async {
        try {
          final result = await AuthService.loginStore(email, password);
          await TokenService.saveToken(result.accessToken);
          await TokenService.saveUser(
            result.user.id,
            result.user.name,
            result.user.email,
          );

          if (!context.mounted) return;

          Navigator.pushReplacementNamed(
            context,
            '/store-home',
            arguments: result.user.name,
          );
        } on VerificationPendingException {
          if (!context.mounted) return;

          AuthRoutes.toVerification(context, email: email, userType: 'store');
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao fazer login: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }
}
