import 'package:flutter/material.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';
import 'package:petgo/routes/auth_routes.dart';

class DeliveryLoginScreen extends StatelessWidget {
  const DeliveryLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return LoginBaseScreen(
      title: 'Login do Entregador',
      subtitle: 'Sua conta para entregar alegria aos tutores de pets.',
      imagePath: 'assets/images/login/petgo_delivery.png',
      imageHeight: 220,
      backgroundColor: const Color(0xFFE5F8E5),
      buttonColor: const Color(0xFF85AB6D),
      onRegisterTap: () {
        Navigator.pushNamed(context, '/delivery-register');
      },
      onLogin: (email, password) async {
        try {
          final result = await AuthService.loginDelivery(email, password);
          await TokenService.saveToken(result.accessToken);
          await TokenService.saveUser(
            result.user.id,
            result.user.name,
            result.user.email,
          );

          if (!context.mounted) return;

          Navigator.pushReplacementNamed(
            context,
            '/delivery-home',
            arguments: result.user.name,
          );
        } on VerificationPendingException {
          if (!context.mounted) return;

          AuthRoutes.toVerification(
            context,
            email: email,
            userType: 'delivery',
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
