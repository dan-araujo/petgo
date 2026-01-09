import 'package:flutter/material.dart';
import 'package:petgo/core/errors/app_exceptions.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login_base_screen.dart';
import 'package:petgo/routes/auth_routes.dart';

class VeterinaryLoginScreen extends StatelessWidget {
  const VeterinaryLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginBaseScreen(
      title: 'Login do Veterinário',
      subtitle: 'Conecte-se e transforme vidas de animais de estimação.',
      imagePath: 'assets/images/login/vet.png',
      imageHeight: 220,
      backgroundColor: const Color(0xFFFFF3E0),
      buttonColor: const Color(0xFFF28C2B),
      onRegisterTap: () {
        Navigator.pushNamed(context, '/veterinary-register');
      },
      onForgotPassword: () {
        AuthRoutes.toForgotPassword(context, userType: 'veterinary');
      },
      onLogin: (email, password) async {
        try {
          final result = await AuthService.loginVeterinary(email, password);
          await TokenService.saveToken(result.accessToken);
          await TokenService.saveUser(
            result.user.id,
            result.user.name,
            result.user.email,
          );

          if (!context.mounted) return;

          Navigator.pushReplacementNamed(
            context,
            '/veterinary-home',
            arguments: result.user.name,
          );
        } on VerificationPendingException {
          if (!context.mounted) return;

          AuthRoutes.toVerification(
            context,
            email: email,
            userType: 'veterinary',
          );
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
