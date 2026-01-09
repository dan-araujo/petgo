import 'package:flutter/material.dart';
import 'package:petgo/core/api/api_endpoints.dart';
import 'package:petgo/core/api/api_service.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/submit_button.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';
import 'package:petgo/routes/auth_routes.dart';

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.post(
        endpoint: ApiEndpoints.registerByType('customer'),
        data: {
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "cpf": _cpfController.text.trim(),
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

      AuthRoutes.toVerification(context, email: email, userType: 'customer');
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
      backgroundColor: const Color(0xFFE8E1FD),
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
                  const SizedBox(height: 8),
                  const Text(
                    'Encontre os melhores cuidados para seu pet',
                    style: TextStyle(fontSize: 14, color: Color(0xFF000000)),
                  ),
                  Image.asset(
                    'assets/images/register/customer_girl_dog.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  AuthFormField(
                    controller: _nameController,
                    label: 'Nome Completo',
                    validator: validatePersonName,
                    focusedBorderColor: const Color(0xFF2596BE),
                  ),
                  AuthFormField(
                    controller: _emailController,
                    label: 'E-mail',
                    inputType: TextInputType.emailAddress,
                    validator: validateEmail,
                    focusedBorderColor: const Color(0xFF2596BE),
                  ),
                  AuthFormField(
                    controller: _phoneController,
                    label: 'Telefone',
                    inputType: TextInputType.phone,
                    validator: validatePhone,
                    focusedBorderColor: const Color(0xFF2596BE),
                  ),
                  AuthFormField(
                    controller: _cpfController,
                    label: 'CPF',
                    inputType: TextInputType.number,
                    isOptional: true,
                    validator: (v) => (v == null || v.isEmpty)
                        ? null
                        : (isValidCPF(v) ? null : 'CPF inválido'),
                    focusedBorderColor: const Color(0xFF2596BE),
                  ),
                  AuthFormField(
                    controller: _passwordController,
                    label: 'Senha',
                    obscure: true,
                    validator: validatePassword,
                    focusedBorderColor: const Color(0xFF2596BE),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: SubmitButton(
                      isLoading: _isLoading,
                      label: 'Cadastrar',
                      color: const Color(0xFF2596BE),
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
