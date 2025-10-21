import 'package:flutter/material.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';

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
              AuthFormField(
                controller: _nameController,
                label: 'Nome Completo',
              ),
              AuthFormField(
                controller: _emailController,
                label: 'E-mail',
                inputType: TextInputType.emailAddress,
                validator: (v) =>
                    v != null && isValidEmail(v) ? null : 'Email inválido',
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
                validator: (v) =>
                  v != null && isValidCPF(v) ? null : 'CPF inválido',
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
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
