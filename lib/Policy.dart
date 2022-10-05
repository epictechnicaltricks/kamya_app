import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/add_address.dart';
import 'package:kamya_app/prefs_file.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'AppDrawer.dart';
import 'Model/address.dart';
import 'Model/address.dart';
import 'Model/address.dart';
import 'Urllink.dart';
import 'home.dart';
class policy extends StatefulWidget {
  @override
  _policyState createState() => _policyState();
}
class _policyState extends State<policy> {
  String radioButtonItem = 'Home';
  String terms = '';
  late String status;
  int id = 1;
  Prefs prefs = new Prefs();
  bool show_button=false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_policy();
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
            title: Text("Privacy Policy"),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              height:MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,

              child:  Html(
                data: terms,),
            ),
          ),
          bottomNavigationBar:
          Visibility(
            visible: show_button,
            child:  Padding(
              padding: const EdgeInsets.only(
                  left: 5, top: 10, right: 5, bottom: 20),
              child:  InkWell(
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppDrawer(
                          child: Home(),
                        ),
                      ));


                },
                child:Container(
                  alignment: Alignment.center,
                  height: 60,
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
                    'DELIVER TO THIS ADDRESS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            ),

          ),
        ),

      ],
    );

  }

  get_policy() async {
    showLoaderDialog(context);
    final url = Urllink.get_policy;
    String user_id = await prefs.ismember_id();
    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,

    });
    print(user_id) ;
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        terms = datauser['data']["policy_msg"] as String;

      });


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
