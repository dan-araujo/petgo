import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/features/auth/bloc/verification_bloc.dart';
import 'package:petgo/features/auth/screens/verification_screen.dart';

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

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      verification: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map;
        final email = args['email'] as String?;
        final userType = args['userType'] as String?;

        if (email == null || userType == null) {
          throw ArgumentError(
            'Email e user type são obrigatórios para verificação',
          );
        }

        return BlocProvider(
          create: (context) => VerificationBloc(),
          child: VerificationScreen(email: email, userType: userType),
        );
      },
    };
  }

  static void toVerification(
    BuildContext context, {
    required String email,
    required String userType,
  }) {
    Navigator.of(context).pushNamed(
      verification,
      arguments: {'email': email, 'userType': userType},
    );
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
