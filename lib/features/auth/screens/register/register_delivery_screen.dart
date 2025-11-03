import 'package:flutter/material.dart';
import 'package:petgo/core/services/api_service.dart';
import 'package:petgo/core/utils/http_error_handler.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/submit_button.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';

class RegisterDeliveryScreen extends StatefulWidget {
  const RegisterDeliveryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate())
      return;

    setState(() => _isLoading = true);

    final result = await ApiService.post(
      endpoint: '/delivery/register',
      data: {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "password": _passwordController.text.trim(),
        if (_cpfController.text.trim().isNotEmpty)
          "cpf": _cpfController.text.trim(),
      },
    );

    if (result['success'] == true) {
      showAppSnackBar(context, 'Cadastro realizado com sucesso!');
      _formKey.currentState!.reset();
    } else {
      final message = getFriendlyErrorMessage(
        result['statusCode'] ?? 400,
        result['message'],
      );
      showAppSnackBar(context, message, isError: true);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Entregador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                validator: validatePhone,
              ),
              AuthFormField(
                controller: _cpfController,
                label: 'CPF',
                inputType: TextInputType.number,
                isOptional: true,
                validator: (v) => (v == null || v.isEmpty)
                    ? null
                    : (isValidCPF(v) ? null : 'CPF inválido'),
              ),
              AuthFormField(
                controller: _passwordController,
                label: 'Senha',
                obscure: true,
                validator: validatePassword,
              ),
              const SizedBox(height: 20),
              SubmitButton(
                isLoading: _isLoading,
                label: 'Cadastrar Entregador',
                color: Colors.teal,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
