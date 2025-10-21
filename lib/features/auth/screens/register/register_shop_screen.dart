import 'package:flutter/material.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';

class RegisterShopScreen extends StatefulWidget {
  const RegisterShopScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterShopScreenState();
}

class _RegisterShopScreenState extends State<RegisterShopScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Petshoop')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AuthFormField(controller: _nameController, label: 'Nome do Estabelecimento'),
              AuthFormField(controller: _emailController, 
              label: 'E-mail', 
              inputType: TextInputType.emailAddress,
              validator: (v) => v != null && isValidEmail(v) ? null : 'Email inválido'),
              AuthFormField(controller: _phoneController, label: 'Telefone', inputType: TextInputType.phone),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(labelText: 'CNPJ'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'CNPJ obrigatório';
                  // Função para validação do CNPJ será feita logo
                  return null;
                },
              ),
              AuthFormField(
                controller: _passwordController,
                label: 'Senha',
                obscure: true,
                validator: validatePassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
