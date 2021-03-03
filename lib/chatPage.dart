import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_blox_aleph/providers/dialogProvider.dart';
import 'package:quick_blox_aleph/services/globalProviders.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: GlobalProviders().dialogProvider),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Consumer<DialogProvider>(
              builder: (key, dialogProvider,child){
                return Text(dialogProvider.cDialogs[dialogProvider.curr].dialog.name);
              },
            )
        ),
        body: Consumer<DialogProvider>(
          builder: (key, dialogProvider, child){
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 80),
              child: ListView.builder(
                reverse: true,
                itemCount: dialogProvider.cDialogs[dialogProvider.curr].messages.length,
                itemBuilder: (context, index){
                  int i = index;
                  int n = dialogProvider.cDialogs[dialogProvider.curr].messages.length;
                  bool myMessage = dialogProvider.qbId == dialogProvider.cDialogs[dialogProvider.curr].messages[n-i-1].senderId;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: myMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          minWidth: 50,
                          maxWidth: MediaQuery.of(context).size.width-70,
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(myMessage ? 8 : 0),
                                bottomRight: Radius.circular(myMessage ? 0 : 8)
                            )
                        ),
                        child: Text(dialogProvider.cDialogs[dialogProvider.curr].messages[n-i-1].body),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: GlobalProviders().dialogProvider.messageController,
                  focusNode: GlobalProviders().dialogProvider.messageFocus,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(35),
                      )
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: (){
                  print('hello');
                  print('creating a message: ${GlobalProviders().dialogProvider.cDialogs[GlobalProviders().dialogProvider.curr].dialog.id}');
                  GlobalProviders().dialogProvider.messageFocus.unfocus();
                  // chatHomeProvider.sendStoppingTypingStatus(chatHomeProvider.cDialogs[chatHomeProvider.currChat].qbDialog.id);
                  GlobalProviders().dialogProvider.sendMessageOneToOne(
                    GlobalProviders().dialogProvider.cDialogs[GlobalProviders().dialogProvider.curr].dialog.id,
                    GlobalProviders().dialogProvider.messageController.text.toString(),
                    [],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
