
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_boilerplate/module_user/manager/user/user_manager.dart';
import 'package:flutter_boilerplate/module_user/model/user/user_model.dart';
import 'package:flutter_boilerplate/module_user/request/user_edit_request/user_edit_equest.dart';
import 'package:inject/inject.dart';
import 'package:rxdart/rxdart.dart';

@provide
class UserService {
  final UserManager _userManager = UserManager();

  UserService();
  final PublishSubject<List<UserModel>> _userPublishSubject =
  new PublishSubject();

  Stream<List<UserModel>> get userStream => _userPublishSubject.stream;
 final List<UserModel> userList = List();
  void requestUsers() async {
    _userManager.getUsers().then((event) {
 List<UserModel> userList = [];
 if(event != null){
   event.forEach((element) { 
      userList.add(UserModel.fromJson(element));
   });
  
 }
   _userPublishSubject.add(userList);
    });
  }

  Future<Map<String ,dynamic>> editProfile(String username ,String token)async{
    EditProfileRequest editReuest = EditProfileRequest(userName:username);
    await _userManager.editProfile(editReuest,token);
   requestUsers();

  }

  void createUser(String uid, String email, String password, String userName)async {
    UserModel user = UserModel(uid: uid , email:email,password: password,userName: userName);
   await _userManager.createUser(user);
   requestUsers();
  }
  
}
