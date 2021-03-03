import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_subscription.dart';
import 'package:quickblox_sdk/push/constants.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class QuickBloxChat {

  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static final QuickBloxChat _singleton = QuickBloxChat._internal();
  List<QBDialog> dialogs = [];
  List<QBSubscription> subscriptions = [];

  factory QuickBloxChat(){
    return _singleton;
  }

  QuickBloxChat._internal();


  connectToChatServer(int login, String password)async{
    print('Connecting to CHat server');
    try {
      await QB.chat.connect(login, password);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  connectionEvents()async{
    //Chat Connections
    //QBChatEvents.CONNECTED
    //QBChatEvents.CONNECTION_CLOSED
    //QBChatEvents.RECONNECTION_FAILED
    //QBChatEvents.RECONNECTION_SUCCESSFUL

    try {
      await QB.chat.subscribeChatEvent(QBChatEvents.CONNECTED, (data) {
        //some logic
      });
    } on PlatformException catch (e) {
        // Some error occured, look at the exception message for more details
      }
  }

  checkConnection()async{
    try {
      bool connected = await QB.chat.isConnected();
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  disconnectFromChatServer()async{
    try {
      await QB.chat.disconnect();
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  removeDialog(String dialogId)async{
    try {
      await QB.chat.deleteDialog(dialogId);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  createOneToOneDialog(int id)async{
    print('QB: Creaating 1-1 dialog with $id');
    try {
      QBDialog createdDialog = await QB.chat.createDialog(
          [id],
          "Private Chat",
          dialogType: QBChatDialogTypes.CHAT);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  getMessageHistory(String dialogId)async{
    try {
      List<QBMessage> messages = await QB.chat.getDialogMessages(
          dialogId,
          markAsRead: true
      );
      print('messageHistory: $messages');
      return messages;
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
    return [];
  }


  sendMessageOneToOne(String dialogId, String messageBody, List<QBAttachment> attachments)async{
    try {
      await QB.chat.sendMessage(
          dialogId,
          body: messageBody,
          attachments: attachments,
          saveToHistory: true);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print("error: create message: $e");
      // String password = await storage.read(key: Arguements.password);
      // connectToChatServer(login, password)
    } catch(e){
      print("error: create message: $e");
    }
  }

  getDialogList()async{
    try {
      dialogs = await QB.chat.getDialogs();
      return dialogs;
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

}