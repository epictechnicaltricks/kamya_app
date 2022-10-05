import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/Urllink.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:kamya_app/profile.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:kamya_app/view_profile.dart';
import 'package:http/http.dart' as http;

import 'AppDrawer.dart';
import 'home.dart';
class otp extends StatefulWidget {
  String user_fname,received_otp,phone,user_id;
  otp(this.user_fname,this.received_otp,this.phone,this.user_id);

  @override
  _otpState createState() => _otpState();
}
class _otpState extends State<otp> {
  late String status;
  TextEditingController mobile_con = new TextEditingController();
  TextEditingController num_con = new TextEditingController();
  TextEditingController num_con1 = new TextEditingController();
  TextEditingController num_con2 = new TextEditingController();
  TextEditingController num_con3 = new TextEditingController();
  TextEditingController num_con4 = new TextEditingController();
  late FocusNode _focusNode;
  Prefs prefs = new Prefs();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(widget.received_otp);
    _focusNode = new FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }
  Widget _boxBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
            child: _box1(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
            child: _box2(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
            child: _box3(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
            child: _box4(),
          ),
        ),






      ],
    );
  }
  Color _getInputTextColor() {
    return _focusNode.hasFocus ? Colors.white : Colors.pink;
  }
  Widget _box1() {
    const texbox_background = const Color(0xFFD5C9B1);
    const color1 = const Color(0xFF474747);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      alignment: Alignment.center,
      height: 70,
      width: 70,

      child: TextField(
        textAlign: TextAlign.center,
        controller: num_con1,
        onChanged: (text) {

          if (text == "") {
            FocusScope.of(context).previousFocus();
          } else {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w800,
        ),
      ),
      decoration: BoxDecoration(
        color: texbox_background,
        border: Border.all(
            color: texbox_background, // set border color
            width: 1.0), // set border width
        borderRadius: BorderRadius.all(
            Radius.circular(35.0)), // set rounded corner radius
        // make rounded corner of border
      ),
    );
  }
  Widget _box2() {
    const color23 = const Color(0xFFeb721f);
    const texbox_background = const Color(0xFFD5C9B1);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      alignment: Alignment.center,
      height: 70,
      width: 70,
      child: TextField(
        textAlign: TextAlign.center,
        controller: num_con2,
        onChanged: (text) {
          print('First text field: $text');

          if (text == "") {
            FocusScope.of(context).previousFocus();
          } else {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w800,
        ),
      ),
      decoration: BoxDecoration(
        color: texbox_background,
        border: Border.all(
            color: texbox_background, // set border color
            width: 1.0), // set border width
        borderRadius: BorderRadius.all(
            Radius.circular(35.0)), // set rounded corner radius
        // make rounded corner of border
      ),
    );
  }

  Widget _box3() {
    const texbox_background = const Color(0xFFD5C9B1);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      alignment: Alignment.center,
      height: 70,
      width: 70,
      child: TextField(
        textAlign: TextAlign.center,
        controller: num_con3,
        onChanged: (text) {
          print('First text field: $text');

          if (text == "") {
            FocusScope.of(context).previousFocus();
          } else {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        style: TextStyle(
          color:Colors.white,
          fontSize: 16,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w800,
        ),
      ),
      decoration: BoxDecoration(
        color: texbox_background,
        border: Border.all(
            color: texbox_background, // set border color
            width: 1.0), // set border width
        borderRadius: BorderRadius.all(
            Radius.circular(35.0)), // set rounded corner radius
        // make rounded corner of border
      ),
    );
  }
  Widget _box4() {
    const texbox_background = const Color(0xFFD5C9B1);
    const color1 = const Color(0xFF474747);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      alignment: Alignment.center,
      height: 70,
      width: 70,
      child: TextField(
        textAlign: TextAlign.center,
        controller: num_con4,
        onChanged: (text) {
          print('First text field: $text');

          if (text == "") {
            FocusScope.of(context).previousFocus();
          } else {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w800,
        ),
      ),
      decoration: BoxDecoration(
        color: texbox_background,
        border: Border.all(
            color: texbox_background, // set border color
            width: 1.0), // set border width
        borderRadius: BorderRadius.all(
            Radius.circular(35.0)), // set rounded corner radius
        // make rounded corner of border
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const texbox_background = const Color(0xFFD5C9B1);
    const button_color = const Color(0xFF28276B);
    const text_color = const Color(0xFFA49981);


    return Stack( // <-- STACK AS THE SCAFFOLD PARENT
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset:true,

          backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
          body:
          SingleChildScrollView(
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
                                  left: 25, top: 140, right: 25, bottom: 0),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: const EdgeInsets.only(
                                        left: 0, top: 0, right: 25, bottom: 3),
                                    child: Text(
                                      'Phone Verification',
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
                                  left: 25, top: 15, right: 20, bottom: 15),
                              child: Text(
                                'Enter Your OTP Code Here',
                                style: TextStyle(
                                  color: text_color,
                                  fontSize: 17,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),


                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, top: 10, right: 15, bottom: 2),
                                    child: _boxBuilder(),
                                  ),
                            InkWell(
                              onTap: () {
                                String num1 = num_con1.text;
                                String num2 = num_con2.text;
                                String num3 = num_con3.text;
                                String num4 = num_con4.text;
                                if (num1 == "") {
                                  Fluttertoast.showToast(
                                      msg: "Please Enter OTP",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor:theme_color.black,
                                      fontSize: 15.0);
                                } else if (num2 == "") {
                                  Fluttertoast.showToast(
                                      msg: "Please Enter OTP",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: theme_color.black,
                                      fontSize: 15.0);
                                } else if (num3 == "") {
                                  Fluttertoast.showToast(
                                      msg: "Please Enter OTP",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: theme_color.black,
                                      fontSize: 15.0);
                                } else if (num4 == "") {
                                  Fluttertoast.showToast(
                                      msg: "Please Enter OTP",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor:theme_color.black,
                                      fontSize: 15.0);
                                } else {
                                  String final_otp =
                                      num1 +
                                          "" +
                                          num2 +
                                          "" +
                                          num3 +
                                          "" +
                                          num4;
                                  if(final_otp==widget.received_otp) {
                                    prefs.setmember_id(widget.user_id);
                                    prefs.setLoggedIn("1");
                                    prefs.setuser_name(widget.user_fname);
                                    prefs.setphone_num(widget.phone);


                                    if(widget.user_fname.length==0)
                                    {

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>  Profile(),

                                        ),
                                      );
                                    }
                                    else{
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>  AppDrawer(
                                              child: Home(),
                                            ),
                                          ));
                                    }

                                  }
                                  else{
                                    setState(() {
                                      Fluttertoast.showToast(
                                          msg: "Invalid OTP.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: theme_color.black,
                                          fontSize: 15.0);

                                    });

                                  }
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
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            Center(
                              child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  margin: const EdgeInsets.only(
                                      left: 5, top: 20, right: 0, bottom: 3),
                                  child: Text(
                                    "Don't your received any code?",
                                    style: TextStyle(
                                      color: theme_color.black,
                                      fontSize: 17,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            ),
                            GestureDetector(
                              onTap:(){
                                send_otp();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 5, right: 0, bottom: 3),
                                    child: Text(
                                      "Resend OTP",
                                      style: TextStyle(
                                        color: theme_color.text_color,
                                        fontSize: 16,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                ],
                              ),

                            )
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


  send_otp() async {
    showLoaderDialog(context);
    var url = Urllink.send_otp;
    final response = await http.post(Uri.parse(url),
        body: {
          "phone": widget.phone,
          "otp": widget.received_otp,
        });

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        Navigator.of(context).pop();

        setState(() {
          Fluttertoast.showToast(
              msg: "OTP Sent",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);

        });
      } else {
        setState(() {
          Navigator.of(context).pop();

          Fluttertoast.showToast(
              msg: "Please try again.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: theme_color.black,
              fontSize: 15.0);

        });
      }

    }
  }

}