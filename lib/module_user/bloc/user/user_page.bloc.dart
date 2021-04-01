import 'package:analyzer_plugin/utilities/pair.dart';

import 'package:flutter_boilerplate/module_user/model/user/user_model.dart';
import 'package:flutter_boilerplate/module_user/service/user/user_service.dart';
import 'package:inject/inject.dart';
import 'package:rxdart/rxdart.dart';


@provide
class UserPageBloc {

  static const STATUS_CODE_INIT = 1588;
  static const STATUS_CODE_GOT_DATA = 1590;


  bool listening = true;

  final UserService _userService = UserService();

  UserPageBloc( );

  final PublishSubject<Pair<int,List<UserModel>>> _userBlocSubject =
      new PublishSubject();

  Stream<Pair<int, List<UserModel>>> get userBlocStream =>
      _userBlocSubject.stream;

  void getUsers() {
    if (!listening) listening = true;
    _userService.userStream.listen((event) {
      _userBlocSubject.add(Pair(STATUS_CODE_GOT_DATA, event));
    });
   _userService.requestUsers();
      
  }

  Future<Map<String ,dynamic>> editProfile( String username,String token)async {
  return await _userService.editProfile(username,token);
  }

 void createUser(String uid , String email,String password , String userName)async {
   
   await _userService.createUser(uid, email,password,userName);

  }

  void dispose() {
    listening = false;
  }

}
