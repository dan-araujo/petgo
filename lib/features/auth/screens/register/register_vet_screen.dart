import 'package:flutter/material.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/submit_button.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';

class RegisterVetScreen extends StatefulWidget {
  const RegisterVetScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterVetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
      // TODO: enviar dados para o backend (Postgres)
      // A partir daqui o usuário vai ser redirecionado a tela de login ou home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Veterinário'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '🐾 Bem-vindo! Crie sua conta de veterinário para começar a oferecer seus serviços.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              AuthFormField(
                controller: _nameController,
                label: 'Nome Completo',
                validator: validatePersonName,
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
              const SizedBox(height: 16),
              AuthFormField(
                controller: _passwordController,
                label: 'Senha',
                obscure: true,
                validator: validatePassword,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: SubmitButton( 
                isLoading: _isLoading,
                label: 'Cadastrar Loja',
                color: Colors.teal,
                onPressed: _submitForm,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
