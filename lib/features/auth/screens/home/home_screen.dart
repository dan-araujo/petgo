import 'package:flutter/material.dart';
import 'package:petgo/features/auth/screens/register/register_customer_screen.dart';
import 'package:petgo/features/auth/screens/register/register_delivery_screen.dart';
import 'package:petgo/features/auth/screens/register/register_shop_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetGo!',
      theme: ThemeData(
        primarySwatch: Colors.teal,
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
      appBar: AppBar(title: const Text('Bem-vindo ao PetGo!')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('Cadastrar Cliente'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const RegisterCustomerScreen()),
                    );
                },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.store),
                  label: const Text('Cadastrar Petshop / Casa de Ração'), 
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed:() {
                    Navigator.push( 
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterShopScreen()),
                    );
                  },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delivery_dining),
                    label: const Text('Cadastrar Entregador'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                     ),
                     onPressed: () {
                      Navigator.push( 
                        context, 
                        MaterialPageRoute(builder: (context) => const RegisterDeliveryScreen()),
                      );
                     },
                     ),
            ],
            )
        ),)
      );
  }
}