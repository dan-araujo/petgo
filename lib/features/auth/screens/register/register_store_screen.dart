import 'package:flutter/material.dart';
import 'package:petgo/core/services/api_service.dart';
import 'package:petgo/core/utils/http_error_handler.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/submit_button.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';

class RegisterStoreScreen extends StatefulWidget {
  const RegisterStoreScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterStoreScreenState();
}

class _RegisterStoreScreenState extends State<RegisterStoreScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _selectedCategory;
  final List<String> _categories = ['PETSHOP', 'FEED_STORE'];

  void _submitForm() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await ApiService.post(
      endpoint: '/stores/register',
      data: {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "password": _passwordController.text.trim(),
        "category": _selectedCategory,
        if (_cnpjController.text.trim().isNotEmpty)
          "cnpj": _cnpjController.text.trim(),
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
      appBar: AppBar(title: const Text('Cadastro de Parceiros')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AuthFormField(
                controller: _nameController,
                label: 'Nome do Estabelecimento',
                validator: validateStoreName,
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
                validator: validatePhone,
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
                          category == 'PETSHOP' ? 'Pet Shop' : 'Casa de Ração',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: validateCategory,
              ),
              AuthFormField(
                controller: _cnpjController,
                label: 'CNPJ',
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'CNPJ obrigatório';
                  return isValidCNPJ(value) ? null : 'CNPJ inválido';
                },
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
                label: 'Cadastrar Loja',
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
