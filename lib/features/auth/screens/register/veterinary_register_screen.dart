import 'package:flutter/material.dart';
import 'package:petgo/core/api/api_endpoints.dart';
import 'package:petgo/core/api/api_service.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/submit_button.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';
import 'package:petgo/routes/auth_routes.dart';

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
  String? _selectedCategory;
  final List<String> _categories = ['SOLO', 'CLINIC'];
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      showAppSnackBar(context, 'Selecione uma categoria', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.post(
        endpoint: ApiEndpoints.registerByType('veterinary'),
        data: {
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "password": _passwordController.text.trim(),
          "category": _selectedCategory,
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

      AuthRoutes.toVerification(context, email: email, userType: 'veterinary');
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
      backgroundColor: const Color(0xFFFFF3E0),
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
                  const SizedBox(height: 6),
                  const Text(
                    'Cadastre-se para oferecer seus serviços',
                    style: TextStyle(fontSize: 14, color: Color(0xFF000000)),
                  ),
                  Image.asset(
                    'assets/images/register/vet_pets.png',
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  AuthFormField(
                    controller: _nameController,
                    label: 'Nome',
                    validator: validateStoreName,
                    focusedBorderColor: const Color(0xFFFF6B35),
                  ),
                  AuthFormField(
                    controller: _emailController,
                    label: 'E-mail',
                    inputType: TextInputType.emailAddress,
                    validator: validateEmail,
                    focusedBorderColor: const Color(0xFFFF6B35),
                  ),
                  AuthFormField(
                    controller: _phoneController,
                    label: 'Telefone',
                    inputType: TextInputType.phone,
                    validator: validatePhone,
                    focusedBorderColor: const Color(0xFFFF6B35),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6B35),
                            width: 2,
                          ),
                        ),
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
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value),
                      validator: validateCategory,
                    ),
                  ),
                  AuthFormField(
                    controller: _passwordController,
                    label: 'Senha',
                    obscure: true,
                    validator: validatePassword,
                    focusedBorderColor: const Color(0xFFFF6B35),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: SubmitButton(
                      isLoading: _isLoading,
                      label: 'Cadastrar',
                      color: const Color(0xFFFF6B35),
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
