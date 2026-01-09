import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/core/navigation/route_args.dart';
import 'package:petgo/features/auth/account-verification/bloc/verification_bloc.dart';
import 'package:petgo/features/auth/forgot-password/screens/forgot_password_flow_page.dart';
import 'package:petgo/features/auth/account-verification/screens/email_verification_screen.dart';

class AuthRoutes {
  static const String customerLogin = '/customer-login';
  static const String customerRegister = '/customer-register';
  static const String deliveryLogin = '/delivery-login';
  static const String deliveryRegister = '/delivery-register';
  static const String storeLogin = '/store-login';
  static const String storeRegister = '/store-register';
  static const String veterinaryLogin = '/veterinary-login';
  static const String veterinaryRegister = '/veterinary-register';

  static const String verification = '/verification';
  static const String forgotPassword = '/forgot-password';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      verification: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as VerificationArgs;

        return BlocProvider(
          create: (_) => VerificationBloc(),
          child: EmailVerificationScreen(
            email: args.email,
            userType: args.userType,
          ),
        );
      },
      forgotPassword: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as ForgotPasswordArgs;
        return ForgotPasswordFlowPage(userType: args.userType);
      },
    };
  }

  static void toVerification(
    BuildContext context, {
    required String email,
    required String userType,
  }) {
    Navigator.pushNamed(
      context,
      verification,
      arguments: VerificationArgs(email: email, userType: userType),
    );
  }

  static void toForgotPassword(BuildContext context, { required String userType }) {
    Navigator.pushNamed(context, forgotPassword, arguments: ForgotPasswordArgs(userType: userType));
  }

  static String getLoginRoute(String userType) {
    switch (userType.toLowerCase()) {
      case 'customer':
        return customerLogin;
      case 'delivery':
        return deliveryLogin;
      case 'store':
        return storeLogin;
      case 'veterinary':
        return veterinaryLogin;
      default:
        return customerLogin;
    }
  }
}
