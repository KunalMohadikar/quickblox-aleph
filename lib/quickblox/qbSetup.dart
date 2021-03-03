import 'package:flutter/services.dart';
import 'package:quick_blox_aleph/keys.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class QuickBloxSetup {

  static final QuickBloxSetup _singleton = QuickBloxSetup._internal();

  factory QuickBloxSetup(){
    return _singleton;
  }

  QuickBloxSetup._internal();

  Future<void> init() async {
    print('QB: init');
    try {
      await QB.settings.init(Keys.APP_ID, Keys.AUTH_KEY, Keys.AUTH_SECRET, Keys.ACCOUNT_KEY);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('error: QBSetup | init: $e');
    } catch(e){
      print('error: $e');
    }
  }

  Future<void> enableAutoReconnect() async {
    print('QB: enableAutoReconnect');
    try {
      await QB.settings.enableAutoReconnect(true);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('error: QBSetup | enableAutoReconnect: $e');
    }
  }

  Future<void> enableCarbons() async {
    print('QB: enableCarbons');
    try {
      await QB.settings.enableCarbons();
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('error: QBSetup | enableCarbons: $e');
    }
  }

  Future<void> initStreamManagement() async {
    print('QB: initStreamManagement');
    try {
      await QB.settings.initStreamManagement(100, autoReconnect: true);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('error: QBSetup | initStreamManagement: $e');
    }
  }

}