import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'AppDrawer.dart';
import 'Model/notification.dart';
import 'Urllink.dart';
import 'home.dart';

class failed extends StatefulWidget {
  @override
  _failedState createState() => _failedState();
}
class _failedState extends State<failed> {
  List notification_list = [];
  List<Notification_list> notification_string = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_notification();
    });

  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
            elevation: 0,
            // automaticallyImplyLeading: false,
            //title: Text("failed"),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body:      Column(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child:Container(
                          margin: const EdgeInsets.only(
                              left: 0, top: 65, right: 0, bottom: 0),
                          height:200,
                          width:200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/empty.png"), // <-- BACKGROUND IMAGE
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child:Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 10, top:120, right: 10, bottom: 10),
                          child: Text(
                            'Your order has failed!',
                            style: TextStyle(
                              color: theme_color.red,
                              fontSize: 24,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                      Center(
                        child:Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 25, top: 5, right: 20, bottom: 10),
                          child: Text(
                            'Sorry something went wrong. please try again to continue your order.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme_color.text_color,
                              fontSize: 18,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppDrawer(
                                  child:  AppDrawer(
                                    child: Home(),
                                  ),
                                ),
                              ));

                        },
                        child:Container(
                          alignment: Alignment.center,
                          height: 60,
                          margin: const EdgeInsets.only(
                              left: 25,
                              top: 100,
                              right: 20,
                              bottom: 10),
                          padding: const EdgeInsets.only(
                              left: 5, top: 10, right: 5, bottom: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [theme_color.button_color,theme_color.button_color]),
                            border: Border.all(
                                color: theme_color.texbox_background, // set border color
                                width: 0.5), // set border width
                            borderRadius: BorderRadius.all(
                                Radius.circular(
                                    30.0)), // set rounded corner radius
                            // make rounded corner of border
                          ),
                          child: Text(
                            'TRY AGAIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            ],
          ),

        ),
      ],
    );
  }

  void onTabTapped(int value) {
    setState(() {
      if (value == 0) {
        /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => My_Order(),
            ));*/
      } else if (value == 1) {
        /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => My_Order_2(),
            ));*/
      } else if (value == 2) {
        /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Setting(),
            ));*/
      }
      else if (value == 3) {
        /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Setting(),
            ));*/
      }

    });
  }
  get_notification() async {
    showLoaderDialog(context);
    final url = Urllink.get_notification;
    http.Response response = await http.post(Uri.parse(url));
    print(url);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        notification_list = datauser['data'] as List;
        notification_string = notification_list.map<Notification_list>(
                (json) => Notification_list.fromJson(json)).toList();
      });
      print('notification_string'+notification_string[0].message);


    }
  }
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Please wait...")),
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
