import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';
import 'Urllink.dart';
import 'otp.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class Login extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobile_con = new TextEditingController();
  late String status;
  late String user_id,user_name;
  Prefs prefs = new Prefs();
  @override
  void initState() {
    _checkPermission();

  }

  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus.isEnabled;
    if (!isGpsOn) {
      print('Turn on location services before requesting permission.');
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    const texbox_background = const Color(0xFFD5C9B1);
    const button_color = const Color(0xFF28276B);

    return Stack( // <-- STACK AS THE SCAFFOLD PARENT
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login-bg.jpg"), // <-- BACKGROUND IMAGE
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
          body:
              SingleChildScrollView(
                    reverse: true,
                    physics: ScrollPhysics(),

    child: Stack(
    children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                      child:Container(
                        margin: const EdgeInsets.only(
                            left: 0, top: 150, right: 0, bottom: 0),
                        height:200,
                          width:200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/logo.png"), // <-- BACKGROUND IMAGE
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ),
          SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                        Container(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                margin: const EdgeInsets.only(
                                    left: 25, top: 170, right: 25, bottom: 0),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: const EdgeInsets.only(
                                          left: 0, top: 0, right: 25, bottom: 3),
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 23,
                                          color:button_color,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                    left: 25, top: 5, right: 20, bottom: 10),
                                child: Text(
                                  'Please sign in to your registered Mobile Number',
                                  style: TextStyle(
                                    color: texbox_background,
                                    fontSize: 18,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                height: 65,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 95,
                                        margin: const EdgeInsets.only(
                                            left: 25, top: 5, right: 25, bottom: 5),
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 5, right: 5, bottom: 5),
                                        alignment: Alignment.topLeft,

                                        decoration: BoxDecoration(
                                          color: texbox_background,
                                          border: Border.all(
                                              color: texbox_background, // set border color
                                              width: 0.5), // set border width
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  25.0)), // set rounded corner radius
                                          // make rounded corner of border
                                        ),
                                        child:TextField(
                                          maxLength: 10,

                                          controller: mobile_con,
                                          decoration: InputDecoration(
                                            counterText: '',
                                            hintText: 'Enter Phone Number',
                                            border: InputBorder.none,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Image.asset(
                                                'assets/mobile.png',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          //  suffixIcon: Icon(Icons.search),
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                  InkWell(
                                  onTap: () {
                                    String num = mobile_con.text;

                                    if(num=='')
                                      {
                                        Fluttertoast.showToast(
                                            msg: "Please Enter Phone Number",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: theme_color.black,
                                            fontSize: 15.0);

                                      }

                                    

                                    else if(num.length<10)
                                    {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Valid Phone Number",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: theme_color.black,
                                          fontSize: 15.0);

                                    }
                                    else{
                                      user_login(num);

                                    }

                                  },
                                      child:Container(
                                        alignment: Alignment.center,
                                        height: 50,
                                        margin: const EdgeInsets.only(
                                            left: 25,
                                            top: 20,
                                            right: 20,
                                            bottom: 10),
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 10, right: 5, bottom: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [button_color,button_color]),
                                          border: Border.all(
                                              color: texbox_background, // set border color
                                              width: 0.5), // set border width
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  25.0)), // set rounded corner radius
                                          // make rounded corner of border
                                        ),
                                        child: Text(
                                          'LOGIN',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: "berkshire-swash",
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ),

                                    //otp
                                  ],
                                ),
                              ),
              ],
            ),
          ),
              ],
                    ),
    ],
    ),
              ),


          ),

      ],
    );
  }
  user_login(phone) async {
    showLoaderDialog(context);
    var url = Urllink.login;
    final response = await http.post(Uri.parse(url),
        body: {
          "phone": phone,
            });

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];

    if (response.statusCode == 200) {
      user_id = datauser["user_id"] as String;
      user_name=datauser['user_fname'] as String;
      String received_otp=datauser['otp'] as String;
      if (status == "0") {
        Navigator.of(context).pop();

        setState(() {
          Fluttertoast.showToast(
              msg: "Please Enter OTP",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => otp(user_name,received_otp,phone,user_id),
              ));

        });
      } else {
        setState(() {
          Navigator.of(context).pop();

          Fluttertoast.showToast(
              msg: "Invalid Credentials.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: theme_color.black,
              fontSize: 15.0);

        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      }

    }
  }
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Sending OTP...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
