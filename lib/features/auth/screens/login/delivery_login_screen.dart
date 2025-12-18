import 'package:flutter/material.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';

class DeliveryLoginScreen extends StatelessWidget {
  const DeliveryLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

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
        final result = await authService.loginDelivery(email, password);

        if(!context.mounted) return;

        await TokenService.saveToken(result.accessToken);
        await TokenService.saveUser(
          result.user.id,
          result.user.name,
          result.user.email,
        );

        if(!context.mounted) return;
        
        Navigator.pushReplacementNamed(
          context,
          '/delivery-home',
          arguments: result.user.name,
        );
      },
    );
  }
}
