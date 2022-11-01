import 'dart:async';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:kamya_app/notifications.dart';
import 'package:kamya_app/prefs_file.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/theme_color.dart';
import 'home.dart';
import 'login.dart';
import 'AppDrawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _color = true;
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Kamya'),
      leading: Builder(
        builder: (BuildContext appBarContext) {
          return IconButton(
              onPressed: () {
                AppDrawer.of(appBarContext)?.toggle();
              },
              icon: Icon(Icons.menu)
          );
        },
      ),
    );
    return  MaterialApp(
         // theme: ThemeData(  primaryColor: theme_color.light_green,),
          // theme: ThemeData(fontFamily: 'Boba-Panda'),
        debugShowCheckedModeBanner: false,

          home: DoubleBack(
            message:"Press back again to close",
            child: SplashScreen(appBar: appBar),
          ),
        );





  }
}
class SplashScreen extends StatefulWidget {
  final AppBar appBar;
  SplashScreen({key, required this.appBar}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Prefs _prefs = new Prefs();
  var isLogin = '0';


  @override
  void initState() {
    super.initState();
    _getPrefsData();
    startTime();
  }





  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async{
    AppBar appBar = AppBar(
      title: Text('Kamya'),
      leading: Builder(
        builder: (BuildContext appBarContext) {
          return IconButton(
              onPressed: () {
                AppDrawer.of(appBarContext)?.toggle();
              },
              icon: Icon(Icons.menu)
          );
        },
      ),
    );

    print(isLogin+"-------->"+"isLoginsss");

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => AppDrawer(
    //         child: Home(),
    //       ),
    //     ));

    if(isLogin=="0")
    {

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));

    }
    else if(isLogin=="1")  // User
        {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppDrawer(
              child: Home(),
            ),
          ));
    }

    
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Kamya'),
      leading: Builder(
        builder: (BuildContext appBarContext) {
          return IconButton(
              onPressed: () {
                AppDrawer.of(appBarContext)?.toggle();
              },
              icon: Icon(Icons.menu)
          );
        },
      ),
    );

    double _width;
    double _height;

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;



    return Container(

      child:  new Image(
        image: AssetImage('assets/splash.png'),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),

    );
  }
  Future _getPrefsData() async {
    isLogin = await _prefs.isLoggedIn();
  }
}
