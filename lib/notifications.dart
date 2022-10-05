import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kamya_app/home.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'Model/notification.dart';
import 'Urllink.dart';
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}
class _NotificationsState extends State<Notifications> {
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
    return Stack(
      fit: StackFit.expand,// <-- STACK AS THE SCAFFOLD PARENT
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_home.png"), // <-- BACKGROUND IMAGE
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
            title: Text("Notification"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home())),
            ),

          ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              height:MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,

              child:ListView.builder(
                  itemCount: notification_string.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.grey),
                          ),
                        ),
                          height:150,
                          child:Row(
                          children: <Widget>[

                            Container(
                            child:Image.asset(
                              'assets/bell.png',
                              height: 15,
                              width: 15,
                              fit: BoxFit.fill,
                            ),

                            margin: const EdgeInsets.only(
                                left: 20, top: 0, right: 4, bottom: 0),
                            padding: const EdgeInsets.all(15),
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(35.0)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],),
                         ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:<Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 10, right: 0, bottom: 5),

                                      margin: const EdgeInsets.only(
                                        left: 20, top:10, right: 4, bottom: 0),
                                      child:Text(
                                        notification_string[index].title,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: theme_color.black,
                                          fontSize: 17,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 280,
                                  child:
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 5, right: 0, bottom: 5),

                                   child: Text(
                                          notification_string[index].message,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(color: Colors.black,),
                                        ),

                                      ),
                                ),


                                Row(
                                  children:<Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 5, right: 0, bottom: 5),
                                      margin: const EdgeInsets.only(
                                        left: 20, top: 0, right: 4, bottom: 0),
                                      child:Text(
                                        notification_string[index].notification_datetime,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: theme_color.black,
                                          fontSize: 13,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            )

                          ],
                      ),

                      ),
                      );

                    },

                  ),

               ),
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
