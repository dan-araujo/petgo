import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/register/customer_register_screen.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return LoginBaseScreen(
      title: 'Login do Cliente',
      subtitle: 'Acesse sua conta para oferecer o melhor para seu companheiro.',
      imagePath: 'assets/images/customer_login_friends.png',
      backgroundColor: const Color(0xFFFFF3E0),
      buttonColor: const Color(0xFFF28C2B),
      onRegisterTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomerRegisterScreen(),
          ),
        );
      },
      onLogin: (email, password) async {
        final result = await authService.loginCustomer(email, password);
        await TokenService.saveToken(result.accessToken);
        await TokenService.saveUser(
          result.user.id,
          result.user.name,
          result.user.email,
        );
      },
    );
  }
}
