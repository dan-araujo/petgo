import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/register/register_veterinary_screen.dart';
import 'package:petgo/features/auth/services/auth_service.dart';
import 'package:petgo/features/auth/services/token_service.dart';
import 'package:petgo/features/auth/widgets/login/login_base_screen.dart';
import 'package:petgo/features/veterinary/screens/veterinary_home_screen.dart';

class VeterinaryLoginScreen extends StatelessWidget {
  const VeterinaryLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return LoginBaseScreen(
      title: 'Login do Veterinário',
      subtitle: 'Conecte-se e transforme vidas de animais de estimação.',
      imagePath: 'assets/images/login_vet.png',
      imageHeight: 190,
      backgroundColor: const Color(0xFFFFF3E0),
      buttonColor: const Color(0xFFF28C2B),
      onRegisterTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VeterinaryRegisterScreen(),
          ),
        );
      },
      onLogin: (email, password) async {
        final result = await authService.loginVeterinary(email, password);
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
                VeterinaryHomeScreen(userName: result.user.name),
          ),
        );
      },
    );
  }
}
