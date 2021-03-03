import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';

class QuickBloxUsers{

  static final QuickBloxUsers _singleton = QuickBloxUsers._internal();

  factory QuickBloxUsers(){
    return _singleton;
  }

  QuickBloxUsers._internal();

  QBUser user;
  List<QBUser> userListID = [];
  List<QBUser> userListFullName = [];

  createUser(String login, String password, String fullName, String email)async{
    try {
      print('QB: creating user:\n$login\n$password\n$fullName');
      user = await QB.users.createUser(
          login,
          password,
          fullName: fullName,
          email: email,
      );
      print('QB: userCreated: $user');
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('error: QB: createUser: $e');
    } catch(e){
      print('error: QB: createUser: $e');
    }
  }

  getUsersById()async{

    print('QB: getUsersById');

    QBFilter qbFilter = new QBFilter();
    qbFilter.field = QBUsersFilterFields.ID;
    qbFilter.operator = QBUsersFilterOperators.IN;
    qbFilter.type = QBUsersFilterTypes.NUMBER;

    try {
      userListID = await QB.users.getUsers(
          // sort: qbSort,
          filter: qbFilter,
          // page: page,
          // perPage: perPage
      );
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  getUserWithoutIds(List<int> ids)async{
    print('QB: getUsersWithoutIds: $ids');

    QBFilter qbFilter = new QBFilter();
    qbFilter.field = QBUsersFilterFields.ID;
    qbFilter.operator = QBUsersFilterOperators.NE;
    qbFilter.type = QBUsersFilterTypes.NUMBER;
    qbFilter.value = ids[0].toString();

    try {
      userListID = await QB.users.getUsers(
        // sort: qbSort,
        filter: qbFilter,
        // page: page,
        // perPage: perPage
      );
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  getUsersByFullName() async {

    print('QB: getUsersByFullName');

    QBFilter qbFilter = new QBFilter();
    qbFilter.field = QBUsersFilterFields.FULL_NAME;
    qbFilter.operator = QBUsersFilterOperators.IN;
    qbFilter.type = QBUsersFilterTypes.STRING;

    try {
      userListFullName = await QB.users.getUsers(
          // sort: qbSort,
          filter: qbFilter
          // page: page,
          // perPage: perPage
      );
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

}