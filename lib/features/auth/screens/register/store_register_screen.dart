import 'package:flutter/material.dart';
import 'package:petgo/core/constants/app_constants.dart';
import 'package:petgo/core/services/api_service.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/submit_button.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';
import 'package:petgo/routes/auth_routes.dart';

class StoreRegisterScreen extends StatefulWidget {
  const StoreRegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StoreRegisterScreenState();
}

class _StoreRegisterScreenState extends State<StoreRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.post(
        endpoint: AppConstants.registerByType('store'),
        data: {
          "name": _nameController.text.trim(),
          "cnpj": _cnpjController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "password": _passwordController.text.trim(),
        },
      );

      if (!mounted) return;
      final success = result['success'] as bool? ?? false;

      if (!success) {
        final message = result['message'] as String? ?? 'Erro ao cadastrar';
        showAppSnackBar(context, message, isError: true);
        return;
      }

      final authData = result['data'] as Map<String, dynamic>? ?? {};
      final message = authData['message'] as String? ?? 'Cadastro realizado!';
      final userData = authData['data'] as Map<String, dynamic>? ?? {};
      final email =
          userData['email'] as String? ?? _emailController.text.trim();

      showAppSnackBar(context, message);

      AuthRoutes.toVerification(context, email: email, userType: 'store');
    } catch (e) {
      if (!mounted) return;

      final errorMessage = e.toString().replaceAll('Exception: ', '');
      showAppSnackBar(context, errorMessage, isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F4),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Junte-se à nossa rede e alcance mais clientes',
                    style: TextStyle(fontSize: 14, color: Color(0xFF000000)),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/register/store_service.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AuthFormField(
                    controller: _nameController,
                    label: 'Nome do Estabelecimento',
                    validator: validateStoreName,
                    focusedBorderColor: const Color(0xFFEC5050),
                  ),
                  AuthFormField(
                    controller: _emailController,
                    label: 'E-mail',
                    inputType: TextInputType.emailAddress,
                    validator: validateEmail,
                    focusedBorderColor: const Color(0xFFEC5050),
                  ),
                  AuthFormField(
                    controller: _phoneController,
                    label: 'Telefone',
                    inputType: TextInputType.phone,
                    validator: validatePhone,
                    focusedBorderColor: const Color(0xFFEC5050),
                  ),
                  AuthFormField(
                    controller: _cnpjController,
                    label: 'CNPJ',
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CNPJ obrigatório';
                      }
                      return isValidCNPJ(value) ? null : 'CNPJ inválido';
                    },
                    focusedBorderColor: const Color(0xFFEC5050),
                  ),
                  AuthFormField(
                    controller: _passwordController,
                    label: 'Senha',
                    obscure: true,
                    validator: validatePassword,
                    focusedBorderColor: const Color(0xFFEC5050),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: SubmitButton(
                      isLoading: _isLoading,
                      label: 'Cadastrar',
                      color: const Color(0xFFEC5050),
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
