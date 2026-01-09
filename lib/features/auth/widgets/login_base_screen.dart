import 'package:flutter/material.dart';
import 'package:petgo/core/errors/app_exceptions.dart';
import 'package:petgo/core/utils/validators.dart';

class LoginBaseScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color backgroundColor;
  final Color buttonColor;
  final double imageHeight;
  final bool imageWithBorderRadius;
  final VoidCallback onRegisterTap;
  final VoidCallback onForgotPassword;
  final Future<void> Function(String email, String password) onLogin;

  const LoginBaseScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.imageHeight = 140.0,
    this.imageWithBorderRadius = false,
    required this.backgroundColor,
    required this.buttonColor,
    required this.onRegisterTap,
    required this.onForgotPassword,
    required this.onLogin,
  });

  @override
  State<StatefulWidget> createState() => _LoginBaseScreenState();
}

class _LoginBaseScreenState extends State<LoginBaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  late final ValueNotifier<bool> _isPasswordValidNotifier = ValueNotifier(
    false,
  );

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      _isPasswordValidNotifier.value = _passwordController.text.length >= 6;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isPasswordValidNotifier.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } on UnauthorizedException catch (e) {
      _showErrorSnackBar(e.message);
    } on ServerException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('Algo deu errado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = 16.0;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.subtitle,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.imageWithBorderRadius 
                      ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.imagePath,
                        height: widget.imageHeight,
                        fit: BoxFit.contain,
                      ),
                    )
                    : Image.asset(
                      widget.imagePath,
                      height: widget.imageHeight,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            }),
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: validatePassword,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: widget.onForgotPassword,
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(color: Color(0xFF0066CC)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isPasswordValidNotifier,
                    builder: (context, isPasswordValid, _) {
                      final buttonColor = isPasswordValid
                          ? widget.buttonColor
                          : widget.buttonColor.withValues(alpha: 0.6);
                      final isEnabled = isPasswordValid && !_isLoading;
                      return ElevatedButton(
                        onPressed: isEnabled ? _onLoginPressed : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          disabledBackgroundColor: widget.buttonColor
                              .withValues(alpha: 0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem conta? '),
                    GestureDetector(
                      onTap: widget.onRegisterTap,
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFF0066CC),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
