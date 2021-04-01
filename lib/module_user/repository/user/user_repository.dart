

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/consts/urls.dart';
import 'package:flutter_boilerplate/module_auth/manager/auth_manager/auth_manager.dart';
import 'package:flutter_boilerplate/module_auth/presistance/auth_prefs_helper.dart';
import 'package:flutter_boilerplate/module_auth/service/auth_service/auth_service.dart';
import 'package:flutter_boilerplate/module_network/http_client/http_client.dart';
import 'package:flutter_boilerplate/module_notifications/service/fire_notification_service/fire_notification_service.dart';
import 'package:flutter_boilerplate/module_user/model/user/user_model.dart';
import 'package:flutter_boilerplate/module_user/request/user_edit_request/user_edit_equest.dart';
import 'package:flutter_boilerplate/utils/logger/logger.dart';
import 'package:inject/inject.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

@provide
class UserRepository {
  final ApiClient _apiClient = ApiClient(Logger());
  Future<List> requestUsers()async {
 
     Map response =await _apiClient.get(Urls.AllPROFILES);
    if (response['status_code'] == '201')
     return null;
     else
    return response['Data'];
  }

  Future<Map<String,dynamic>> editProfile(EditProfileRequest request,String token) async{

    dynamic response = await _apiClient.put(
      '${Urls.PROFILE}',
    request.toJson(),
      headers: {'Authorization': 'Bearer ' + token},
    );
   return response['Data'];
  }

 Future<Map> createUser(UserModel user) async{
   print('before register');
   print(user.uid);
    Map response =await _apiClient.post(Urls.API_SIGN_UP,{'userID':user.uid,'password':user.password,'email':user.email,'userName':user.userName});
    print(response['Data']);
    return response['Data'];
  }
}


