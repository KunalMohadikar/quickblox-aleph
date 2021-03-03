import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';

class QuickBloxAuth{

  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static final QuickBloxAuth _singleton = QuickBloxAuth._internal();

  factory QuickBloxAuth(){
    return _singleton;
  }

  QuickBloxAuth._internal();

  QBSession session;
  QBUser qbUser;
  QBSession qbSession;
  QBLoginResult result;


  getSession()async{
    try {
      print('getting application session');
      qbSession = await QB.auth.getSession();
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('quickblox | getSession: $e');
    }
  }

  checkUserExists(String userId)async{
    QBFilter qbFilter = QBFilter();
    qbFilter.value = userId;
    qbFilter.field = QBUsersFilterFields.LOGIN;
    qbFilter.operator = QBUsersFilterOperators.EQ;
    qbFilter.type = QBUsersFilterTypes.STRING;

    List<QBUser> users = await QB.users.getUsers(
      filter: qbFilter,
    );

    if(users.length!=0 && users[0].login == userId){
      return true;
    }
    return false;
  }

  loginUser(String login, String password)async{
    print('QB: Logging in: $login');
    try {
      result = await QB.auth.login(login, password);
      qbUser = result.qbUser;
      qbSession = result.qbSession;
      await secureStorage.write(key: "qbId", value: qbUser.id.toString());
      await secureStorage.write(key: "password", value: password);

    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('quickblox | loginUser: $e');
    }
  }

  logoutUser()async{
    try {
      await QB.auth.logout();
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('quickblox | logoutUser: $e');
    }
  }

}