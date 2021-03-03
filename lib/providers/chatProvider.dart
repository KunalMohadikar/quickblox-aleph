import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier{

  

  bool isDisposed = false;

  List<String> messages = [];

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
    super.dispose();
  }

}