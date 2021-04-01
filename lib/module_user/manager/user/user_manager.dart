import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/module_user/model/user/user_model.dart';
import 'package:flutter_boilerplate/module_user/repository/user/user_repository.dart';
import 'package:flutter_boilerplate/module_user/request/user_edit_request/user_edit_equest.dart';
import 'package:inject/inject.dart';


@provide
class UserManager {
  final UserRepository _userRepository =UserRepository();

  UserManager();

  Future<List> getUsers()async {
    return await _userRepository.requestUsers();
  }

  Future<Map<String ,dynamic>> editProfile(EditProfileRequest request,token)async {
  return  await _userRepository.editProfile(request,token);
  }

  Future<Map> createUser(UserModel user) async{
    return await _userRepository.createUser(user);
  }
}
