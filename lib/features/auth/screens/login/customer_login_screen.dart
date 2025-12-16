import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/register/customer_register_screen.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';
import 'package:petgo/features/customer/screens/customer_home_screen.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return LoginBaseScreen(
      title: 'Login do Cliente',
      subtitle: 'Acesse sua conta para oferecer o melhor para seu companheiro.',
      imagePath: 'assets/images/login_customer.png',
      backgroundColor: const Color(0xFFE8E1FD),
      buttonColor: const Color(0xFF2596BE),
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

        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CustomerHomeScreen(userName: result.user.name),
          ),
        );
      },
    );
  }
}
