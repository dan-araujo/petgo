import 'package:flutter/material.dart';

class DeliveryHomeScreen extends StatelessWidget {
  final String userName;

  const DeliveryHomeScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('petgo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFFE5F8E5),
              child: Padding(padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.pets,
                    size: 40,
                    color: Color(0xFF85AB6D),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          'Bem-vindo, $userName!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pronto para fazer entregas que deixam os pets mais felizes?',
                          style: const TextStyle( 
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    ),
                ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Explorar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}