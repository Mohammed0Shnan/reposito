
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/abstracts/module/yes_module.dart';
import 'package:flutter_boilerplate/module_chat/chat_routes.dart';
import 'package:flutter_boilerplate/module_user/ui/ui/screens/user_page/user_page.dart';
import 'package:inject/inject.dart';

@provide
class UserModule extends YesModule {
  final UserPage _userPage;
  UserModule(this._userPage);
  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      ChatRoutes.chatRoute: (context) =>_userPage,
    };
  }
}
