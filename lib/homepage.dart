import 'package:flutter/material.dart';
import 'package:quick_blox_aleph/quickblox/qbAuthentication.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController loginController = TextEditingController(text: "5fface82168e065cef2a34ef");
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: loginController,
            decoration: InputDecoration(
              hintText: 'Login',
            ),
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          FlatButton(
            child: Text('Login'),
            onPressed: ()async{
              await QuickBloxAuth().loginUser(loginController.text, passwordController.text);
              Navigator.pushNamed(context, '/dialogsPage');
            },
          )
        ],
      ),
    );
  }
}
