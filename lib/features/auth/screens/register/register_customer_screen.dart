import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petgo/core/utils/http_error_handler.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'dart:convert';
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
  bool _isLoading = false;
  final String customerUrl = 'http://10.0.2.2:3000/customers/register';

  void _submitForm() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate())
      return;

    setState(() => _isLoading = true);

    final url = Uri.parse(customerUrl);

    final body = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneController.text.trim(),
      "password": _passwordController.text.trim(),
      if (_cpfController.text.trim().isNotEmpty)
        "cpf": _cpfController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (!mounted) return;
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        showAppSnackBar(context, 'Cadastro realizado com sucesso!');
        _formKey.currentState!.reset();
      } else {
        final message = getFriendlyErrorMessage(
          response.statusCode,
          responseData['message'],
        );
        showAppSnackBar(context, message, isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Erro de conexão. Verifique sua internet.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AuthFormField(
                controller: _nameController,
                label: 'Nome Completo',
                validator: validateName,
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
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 168, 31, 31),
                      )
                    : const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
