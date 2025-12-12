import 'package:flutter/material.dart';
import 'package:petgo/core/services/api_service.dart';
import 'package:petgo/core/utils/http_error_handler.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/submit_button.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';

class VeterinaryRegisterScreen extends StatefulWidget {
  const VeterinaryRegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<VeterinaryRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _selectedCategory;
  final List<String> _categories = ['SOLO', 'CLINIC'];

  void _submitForm() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await ApiService.post(
      endpoint: '/veterinaries/register',
      data: {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "password": _passwordController.text.trim(),
        "category": _selectedCategory,
      },
    );

    if (!mounted) return;
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
    setState(() => _isLoading = false);
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
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category == 'CLINIC'
                              ? 'Clínica Veterinária'
                              : 'Veterinário Autônomo',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: validateCategory,
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
                  label: 'Cadastrar Veterinário',
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
