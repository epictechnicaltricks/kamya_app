import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/prefs_file.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'AppDrawer.dart';
import 'Model/notification.dart';
import 'Urllink.dart';
import 'home.dart';
import 'package:kamya_app/shopping_list.dart';

class add_shopping_list extends StatefulWidget {
  @override
  _add_shopping_listState createState() => _add_shopping_listState();
}
class _add_shopping_listState extends State<add_shopping_list> {
  Prefs prefs = new Prefs();

  TextEditingController shopping_list_txt = new TextEditingController();
  String radioButtonItem = 'Home';
  late String status;
  int id = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack( // <-- STACK AS THE SCAFFOLD PARENT
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
            title: Text("Add New Shopping List"),
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
                margin: const EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),

                child:Column(
                  children: [
                    Container(
                      height: 55,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 0, right: 15, bottom: 0),
                        padding: const EdgeInsets.only(
                            left: 15, top: 0, right: 5, bottom: 0),
                        alignment: Alignment.topLeft,
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Shopping List Name',
                          ),
                          controller: shopping_list_txt,
                          style: new TextStyle(
                            fontFamily: "Roboto",
                            color: theme_color.black,
                            fontSize: 16,

                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                          InkWell(
                            onTap: () {
                              String list_name = shopping_list_txt.text;

                              if(list_name=='')
                              {
                                Fluttertoast.showToast(
                                    msg: "Please Enter List Name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: theme_color.black,
                                    fontSize: 15.0);

                              }

                              else{

                                add_shopping_list(list_name);
                              }

                            },

                                child:Container(
                                  alignment: Alignment.center,
                                  height: 60,
                                  margin: const EdgeInsets.only(
                                      left: 5, top: 10, right: 5, bottom: 10),

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
                                    'ADD NEW SHOPPING LIST',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),


                          ),

                      ],
                    ),

                  ],
                )
            ),


          ),
        ),

      ],
    );
  }



  add_shopping_list(String list_name) async {
    showLoaderDialog(context);

    var url = Urllink.add_shopping_list;
    String user_id = await prefs.ismember_id();
    final response = await http.post(Uri.parse(url),
        body: {
          "user_id": user_id,
          "list_name": list_name,

        });

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];

    if (response.statusCode == 200) {
      Navigator.pop(context);

      if (status == "0") {
        setState(() {
          Fluttertoast.showToast(
              msg: "New List Created Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);
        });
      } else {
        Navigator.pop(context);
        setState(() {
          Fluttertoast.showToast(
              msg: "Something went wrong.Please Try Again.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: theme_color.black,
              fontSize: 15.0);
        });
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => shopping_list(),
          ));
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

