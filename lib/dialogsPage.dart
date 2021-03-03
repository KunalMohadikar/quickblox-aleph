import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_blox_aleph/providers/dialogProvider.dart';
import 'package:quick_blox_aleph/quickblox/qbAuthentication.dart';
import 'package:quick_blox_aleph/quickblox/qbSetup.dart';
import 'package:quick_blox_aleph/services/globalProviders.dart';

class DialogsPage extends StatefulWidget {
  @override
  _DialogsPageState createState() => _DialogsPageState();
}

class _DialogsPageState extends State<DialogsPage> {
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
}
