import 'package:flutter/material.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';
import 'package:petgo/routes/auth_routes.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return LoginBaseScreen(
      title: 'Login do Cliente',
      subtitle: 'Acesse sua conta para oferecer o melhor para seu companheiro.',
      imagePath: 'assets/images/login/man_best_friend.png',
      backgroundColor: const Color(0xFFE8E1FD),
      buttonColor: const Color(0xFF2596BE),
      onRegisterTap: () {
        Navigator.pushNamed(context, '/customer-register');
      },
      onLogin: (email, password) async {
        try {
          final result = await AuthService.loginCustomer(email, password);
          await TokenService.saveToken(result.accessToken);
          await TokenService.saveUser(
            result.user.id,
            result.user.name,
            result.user.email,
          );

          if (!context.mounted) return;

          Navigator.pushReplacementNamed(
            context,
            '/customer-home',
            arguments: result.user.name,
          );
        } on VerificationPendingException {
          if (!context.mounted) return;

          AuthRoutes.toVerification(
            context,
            email: email,
            userType: 'customer',
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
