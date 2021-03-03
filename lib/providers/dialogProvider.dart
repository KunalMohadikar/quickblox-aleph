import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quick_blox_aleph/models/customDialog.dart';
import 'package:quick_blox_aleph/quickblox/qbChat.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class DialogProvider with ChangeNotifier{

  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocus = FocusNode();
  int qbId;

  bool isDisposed = false;
  List<CustomDialog> cDialogs = [];
  StreamSubscription<dynamic> newMessageSubscription;

  int curr = -1;

  Future<void> subscribeNewMessageSubscription()async{
    print('QB: subscribeNewMessageSubscription');
    if(newMessageSubscription != null){
      return;
    }
    try {
      newMessageSubscription = await QB.chat.subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE, (data) {
        Map<String, Object> map = new Map<String, dynamic>.from(data);
        print('revieved chat map: $map');
        Map<String, Object> payload = new Map<String, dynamic>.from(map["payload"]);
        // String _messageId = payload["id"];
        print('received payload of a new message: $payload');
        int index = findDialog(payload['dialogId']);
        print('index: $index');
        QBMessage message = QBMessage();
        message.id = payload['id'];
        message.body = payload['body'];
        message.dateSent = payload['dateSent'];
        message.senderId = payload['senderId'];
        message.delayed = payload['delayed'];
        message.dialogId = payload['dialogId'];
        if(payload['attachments']!=null){
          message.attachments = payload['attachments'];
        }
        cDialogs[index].messages.add(message);
        notifyListeners();
      });
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
      print('error: subscribeNewMessageSubscription: $e');
    }
  }

  Future<void> cancelNewMessageSubscription()async{
    print('QB: cancelNewMessageSubscription');
    if(newMessageSubscription!=null){
      await newMessageSubscription.cancel();
    }
    newMessageSubscription = null;
  }

  getDialogs()async{
    String qbId = await secureStorage.read(key: "qbId");
    String password = await secureStorage.read(key: "password");
    this.qbId = int.parse(qbId);
    print('--------------------connecting to chat server--------------------');
    await QuickBloxChat().connectToChatServer(int.parse(qbId), password);
    print('--------------------Subscribe Receive New Messages----------------');
    await subscribeNewMessageSubscription();

    List<QBDialog> dialogs = await QuickBloxChat().getDialogList();
    for(int i=0;i<dialogs.length;i++){
      cDialogs.add(CustomDialog(dialog: dialogs[i]));
    }
    notifyListeners();
  }

  findDialog(String dialogId){
    CustomDialog cDialog = cDialogs.firstWhere((dialog) => dialog.dialog.id == dialogId,
        orElse: (){
          return null;
        });
    return cDialogs.indexOf(cDialog);

  }

  sendMessageOneToOne(String dialogId, String messageBody, List<QBAttachment> attachments)async{
    messageController.text = "";
    notifyListeners();
    await QuickBloxChat().sendMessageOneToOne(
      dialogId,
      messageBody,
      attachments,
    );
  }

  DialogProvider(){
    getDialogs();
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    if(!isDisposed){
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isDisposed = true;
    cancelNewMessageSubscription();
    super.dispose();
  }


}