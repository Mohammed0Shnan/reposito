
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/abstracts/module/yes_module.dart';
import 'package:inject/inject.dart';

import 'authorization_routes.dart';

@provide
class AuthorizationModule extends YesModule {
  AuthorizationModule() {}

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      AuthorizationRoutes.LOGIN_SCREEN: (context) => Scaffold(),
      AuthorizationRoutes.REGISTER_SCREEN: (context) => Scaffold(),
    };
  }
}
