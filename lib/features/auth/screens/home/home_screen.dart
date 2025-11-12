import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/register/register_customer_screen.dart';
import 'package:petgo/features/auth/screens/register/register_delivery_screen.dart';
import 'package:petgo/features/auth/screens/register/register_store_screen.dart';
import 'package:petgo/features/auth/screens/register/register_veterinary_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetGo!',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF7F4),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF8E44AD),
          secondary: const Color(0xFFFF8C8C),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
  child: LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView( 
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight, 
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/pets_welcome.png',
                  height: MediaQuery.of(context).size.height * 0.30, 
                  fit: BoxFit.contain,
                ),

                Text(
                  'Bem-vindo ao\nPetGo!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 5),

                _buildOptionButton(
                  context,
                  icon: Icons.person,
                  label: 'Sou Cliente',
                  color: const Color(0xFF9B59B6),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterCustomerScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),

                _buildOptionButton(
                  context,
                  icon: Icons.store,
                  label: 'Sou Parceiro',
                  color: const Color(0xFF9B59B6),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterStoreScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildOptionButton(
                  context,
                  icon: Icons.delivery_dining,
                  label: 'Sou Entregador',
                  color: const Color(0xFF9B59B6),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterDeliveryScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),

                _buildOptionButton(
                  context,
                  icon: Icons.pets,
                  label: 'Sou Veterinário',
                  color: const Color(0xFF9B59B6),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterVeterinaryScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.deepPurple.shade800),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE6E6),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onPressed,
    );
  }
}
