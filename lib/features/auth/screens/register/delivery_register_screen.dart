import 'package:flutter/material.dart';
import 'package:petgo/core/constants/app_constants.dart';
import 'package:petgo/core/services/api_service.dart';
import 'package:petgo/core/utils/http_error_handler.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/submit_button.dart';
import 'package:petgo/features/auth/widgets/auth_form_field.dart';
import 'package:petgo/routes/auth_routes.dart';

class DeliveryRegisterScreen extends StatefulWidget {
  const DeliveryRegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<DeliveryRegisterScreen> {
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
      print('🚀 === INICIANDO CADASTRO ===');
      print('📧 Email: ${_emailController.text.trim()}');
      print('👤 Nome: ${_nameController.text.trim()}');

      final result = await ApiService.post(
        endpoint: AppConstants.registerByType('delivery'),
        data: {
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "password": _passwordController.text.trim(),
          if (_cpfController.text.trim().isNotEmpty)
            "cpf": _cpfController.text.trim(),
        },
      );

      print('📦 === RESPOSTA DO BACKEND ===');
      print('Resposta completa: $result');
      print('Success: ${result['success']}');
      print('Data: ${result['data']}');

      if (!mounted) return;

      if (result['success'] == true) {
        final data = result['data'];

        print('📊 === ANALISANDO DATA ===');
        print('Data é null? ${data == null}');
        print('Data tipo: ${data.runtimeType}');

        if (data != null) {
          print('Status no data: ${data['status']}');
          print('Email no data: ${data['email']}');
          print('UserId no data: ${data['userId']}');
        }

        // ✅ CORREÇÃO: Verifica se status existe E é pending_code/new_sent_code
        if (data != null &&
            data['status'] != null &&
            (data['status'] == 'new_sent_code' ||
                data['status'] == 'pending_code')) {
          final email = data['email'] ?? _emailController.text.trim();

          print('✅ === REDIRECIONANDO PARA VERIFICAÇÃO ===');
          print('Email: $email');
          print('UserType: delivery');

          AuthRoutes.toVerification(
            context,
            email: email,
            userType: 'delivery',
          );
          return;
        }

        print('⚠️ Status não é pending_code, indo para login');
        showAppSnackBar(context, 'Cadastro realizado com sucesso!');
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/delivery-login',
          (route) => false,
        );
        _formKey.currentState!.reset();
      } else {
        print('❌ Success é false');
        final message = getFriendlyErrorMessage(
          result['statusCode'] ?? 400,
          result['message'],
        );
        showAppSnackBar(context, message, isError: true);
      }
    } catch (e, stackTrace) {
      print('❌ === ERRO NO CADASTRO ===');
      print('Erro: $e');
      print('StackTrace: $stackTrace');

      if (!mounted) return;
      showAppSnackBar(context, 'Erro ao cadastrar: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F8E5),
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
                    'Comece a entregar com a gente e ganhe enquanto ajuda pets',
                    style: TextStyle(fontSize: 14, color: Color(0xFF000000)),
                  ),
                  Image.asset(
                    'assets/images/register/delivery_motorbike.png',
                    height: 190,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  AuthFormField(
                    controller: _nameController,
                    label: 'Nome Completo',
                    validator: validatePersonName,
                    focusedBorderColor: const Color(0xFF85AB6D),
                  ),
                  AuthFormField(
                    controller: _emailController,
                    label: 'E-mail',
                    inputType: TextInputType.emailAddress,
                    validator: validateEmail,
                    focusedBorderColor: const Color(0xFF85AB6D),
                  ),
                  AuthFormField(
                    controller: _phoneController,
                    label: 'Telefone',
                    inputType: TextInputType.phone,
                    validator: validatePhone,
                    focusedBorderColor: const Color(0xFF85AB6D),
                  ),
                  AuthFormField(
                    controller: _cpfController,
                    label: 'CPF',
                    inputType: TextInputType.number,
                    isOptional: true,
                    validator: (v) => (v == null || v.isEmpty)
                        ? null
                        : (isValidCPF(v) ? null : 'CPF inválido'),
                    focusedBorderColor: const Color(0xFF85AB6D),
                  ),
                  AuthFormField(
                    controller: _passwordController,
                    label: 'Senha',
                    obscure: true,
                    validator: validatePassword,
                    focusedBorderColor: const Color(0xFF85AB6D),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: SubmitButton(
                      isLoading: _isLoading,
                      label: 'Cadastrar',
                      color: const Color(0xFF85AB6D),
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
