import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_boilerplate/utils/logger/logger.dart';
import 'package:inject/inject.dart';
import 'package:rxdart/subjects.dart';

@provide
class FireNotificationService {

  static final PublishSubject<String> _onNotificationRecieved =
      PublishSubject();
  static Stream get onNotificationStream => _onNotificationRecieved.stream;

  static StreamSubscription iosSubscription;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<void> init() async {
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
  }

  Future<void> refreshNotificationToken(String userAuthToken) async {
    var token = await _fcm.getToken();
    print('Token: $token');
    if (token != null && userAuthToken != null) {

      // And Subscribe to the changes
      this._fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          Logger().info('FireNotificationService', 'onMessage: $message');
          _onNotificationRecieved.add(message.toString());
        },
        onLaunch: (Map<String, dynamic> message) async {
          Logger().info('FireNotificationService', 'onMessage: $message');
        },
        onResume: (Map<String, dynamic> message) async {
          Logger().info('FireNotificationService', 'onMessage: $message');
        },
      );
    }
  }
}
