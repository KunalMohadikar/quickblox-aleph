import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quick_blox_aleph/quickblox/qbAuthentication.dart';
import 'package:quick_blox_aleph/quickblox/qbSetup.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  initialiseQB()async{
    await Future.delayed(Duration(seconds: 1));
    await QuickBloxSetup().init();
    bool exists = await secureStorage.containsKey(key: "qbId");
    if(exists){
      Navigator.pushReplacementNamed(context, '/dialogsPage');
    }
    else{
      Navigator.pushReplacementNamed(context, '/homePage');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseQB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Loading'),
          ],
        ),
      ),
    );
  }
}
