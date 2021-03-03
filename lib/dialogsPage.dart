import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:quick_blox_aleph/providers/dialogProvider.dart';
import 'package:quick_blox_aleph/quickblox/qbAuthentication.dart';
import 'package:quick_blox_aleph/quickblox/qbChat.dart';
import 'package:quick_blox_aleph/quickblox/qbSetup.dart';
import 'package:quick_blox_aleph/services/globalProviders.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class DialogsPage extends StatefulWidget {
  @override
  _DialogsPageState createState() => _DialogsPageState();
}

class _DialogsPageState extends State<DialogsPage> with WidgetsBindingObserver  {

  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  connectToChatServer()async{
    String qbId = await secureStorage.read(key: "qbId");
    String password = await secureStorage.read(key: "password");
    print('--------------------connecting to chat server--------------------');
    await QuickBloxChat().connectToChatServer(int.parse(qbId), password);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        try {
          print('App is resumed');
          connectToChatServer();
          GlobalProviders().dialogProvider.subscribeNewMessageSubscription();
        } on PlatformException catch (e) {
          // Some error occured, look at the exception message for more details
        }
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        try {
          GlobalProviders().dialogProvider.cancelNewMessageSubscription();
          QB.chat.disconnect();
        } on PlatformException catch (e) {
          // Some error occured, look at the exception message for more details
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DialogProvider>(create: (_)=>GlobalProviders().dialogProvider,),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dialog'),
        ),
        body: Consumer<DialogProvider>(
          builder: (key, dialogProvider, child){
            return Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: dialogProvider.cDialogs.length,
                      itemBuilder: (context, index){
                        int i = index;
                        return ListTile(
                          onTap: (){
                            Navigator.pushNamed(context, '/chatPage', arguments: i);
                            dialogProvider.curr = i;
                            dialogProvider.notifyListeners();
                          },
                          title: Text(dialogProvider.cDialogs[i].dialog.name),
                        );
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: ()async{
                      await QuickBloxAuth().logoutUser();
                      await dialogProvider.secureStorage.deleteAll();
                      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (route) => false);
                    },
                    child: Text('logout'),
                  ),
                ],
              ),
            );
          },
        )
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    GlobalProviders().dialogProvider = DialogProvider();
    super.dispose();
  }
}
