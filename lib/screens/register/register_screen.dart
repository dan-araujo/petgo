import 'package:flutter/material.dart';
import 'package:petgo/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();

  VoidCallback? get _submitForm => null;

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Enviar dados para o back-end (Postgres)
      print('Cadastro enviado!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome Completo'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe seu nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    !value!.contains('@') ? 'Informe um e-mail válido' : null,
              ),
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Digite seu CPF',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O CPF é obrigatório';
                  } else if (!isValidCPF(value)) {
                    return 'CPF inválido';
                  }
                  return null; // CPF validado
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (value) => value!.length < 6
                    ? 'Senha deve ter no mínimo 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
