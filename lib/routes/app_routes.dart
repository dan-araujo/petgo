import 'package:flutter/material.dart';
import 'package:petgo/routes/auth_routes.dart';
import 'package:petgo/routes/customer_routes.dart';
import 'package:petgo/routes/delivery_routes.dart';
import 'package:petgo/routes/store_routes.dart';
import 'package:petgo/routes/veterinary_routes.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      ...AuthRoutes.getRoutes(),
      ...VeterinaryRoutes.getRoutes(),
      ...CustomerRoutes.getRoutes(),
      ...StoreRoutes.getRoutes(),
      ...DeliveryRoutes.getRoutes(),
    };
  }
}