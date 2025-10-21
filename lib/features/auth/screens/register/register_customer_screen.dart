import 'package:flutter/material.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';

class RegisterCustomerScreen extends StatefulWidget {
  const RegisterCustomerScreen({super.key});

  @override
  State<RegisterCustomerScreen> createState() => _RegisterCustomerScreenState();
}

class _RegisterCustomerScreenState extends State<RegisterCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();


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
      appBar: AppBar(title: const Text('Cadastro de Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              AuthFormField(
                controller: _nameController,
                label: 'Nome Completo',
              ),
              AuthFormField(
                controller: _emailController,
                label: 'E-mail',
                inputType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              AuthFormField(
                controller: _phoneController,
                label: 'Telefone',
                inputType: TextInputType.phone,
              ),
              AuthFormField(
                controller: _cpfController,
                label: 'CPF',
                inputType: TextInputType.number,
                isOptional: true,
                validator: (v) =>
                  (v == null || v.isEmpty) ? null : (isValidCPF(v) ? null : 'CPF inválido'),
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
