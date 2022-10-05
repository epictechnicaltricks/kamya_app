import 'dart:convert';
import 'dart:io';
import 'package:kamya_app/Urllink.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/profile.dart';
import 'package:kamya_app/setting.dart';
import 'package:kamya_app/shopping_list.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;

import 'AppDrawer.dart';
import 'Model/shopping_list.dart';
import 'home.dart';
import 'list_product.dart';
import 'login.dart';
import 'my_order.dart';

class view_profile extends StatefulWidget {
  @override
  _view_profileState createState() => _view_profileState();
}

class _view_profileState extends State<view_profile> {

  String f_payment = "";
  Prefs prefs = new Prefs();
  String status = "";
  String profilePic = "";
  List<shopping_list_model> shopping_string = [];
  List shoppinglist = [];

  TextEditingController first_con = new TextEditingController();
  TextEditingController last_con = new TextEditingController();
  TextEditingController mobile_con = new TextEditingController();
  TextEditingController email_con = new TextEditingController();
  String _fileName_1 = "";

  late String member_id;

  String user_fname = "";
  String user_lname = "";
  String user_email = "";
  String user_phno = "";
  String country_id = "";
  String user_pic = "";
  String user_pincode='';

  String use_lang = "";
  String lable_1 = "";
  String lable_2 = "";
  String lable_3 = "";
  String lable_4 = "";
  String lable_5 = "";
  String lable_6 = "";
  String lable_7 = "";
  String lable_8 = "";
  String lable_9 = "";
  String lable_10 = "";
  String lable_11 = "";
  String lable_12 = "";
  String lable_13 = "";
  late String token;
  String Camera="";
  String Gallery="";



  get_shopping_list() async {
    var url = Urllink.get_shopping_list;
    String user_id = await prefs.ismember_id();
    final response = await http.post(Uri.parse(url),
        body: {
          "user_id": user_id,
        });

    Map<String, dynamic> datauser = json.decode(response.body);
    print(datauser);
    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          shoppinglist = datauser['data'] as List;
          shopping_string = shoppinglist.map<shopping_list_model>(
                  (json) => shopping_list_model.fromJson(json)).toList();

        });
      } else {
        setState(() {

        });

      }

    }
    showLoaderDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(left: 7),
                child: Text("Please wait...")),
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

  @override
  void initState() {
    // TODO: implement initState
    getget_profile();
    get_shopping_list();
    super.initState();


  }

   dynamic _image;



  getget_profile() async {
    var url = Urllink.get_profile;
    String user_id = await prefs.ismember_id();
    String token='';
    final response =
    await http.post(Uri.parse(url), body: {"user_id": user_id,"token": token});

    Map<String, dynamic> datauser = json.decode(response.body);
    print("datauser ::  ${datauser}");

    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          //  Navigator.pop(context);

          user_fname = datauser['data'][0] ["user_fname"] as String;
          user_lname = datauser['data'][0] ["user_lname"] as String;
          user_email = datauser['data'][0] ["user_email"] as String;
          country_id = datauser['data'][0] ["country_id"] as String;
          user_phno = datauser['data'][0] ["user_phno"] as String;
          user_pic = datauser['data'][0] ["profile_pic"] as String;
          user_pincode=datauser['data'][0] ["user_pincode"] as String;

          first_con.text = user_fname;
          last_con.text = user_lname;
          email_con.text = user_email;

        });
      } else {
        setState(() {
          Navigator.pop(context);
        });

      }
    }
  }

  Add_Img() {

    if (_fileName_1 != "") {
      return Stack(
        children: <Widget>[
          Container(
            margin:
            const EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 0),
            padding:
            const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    theme_color.button_color,
                    theme_color.button_color
                  ]),
              border: Border.all(
                  color: theme_color.button_color, // set border color
                  width: 0.5), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(50.0)), // set rounded corner radius
              // make rounded corner of border
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Image.file(
                File(_image),
                height: 90,
                width: 90,
                fit: BoxFit.fill,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                //_openFileExplorer();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: 75, top: 15, right: 10, bottom: 0),
              padding:
              const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [theme_color.button_color, theme_color.button_color]),
                border: Border.all(
                    color: theme_color.button_color, // set border color
                    width: 0.5), // set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(30.0)), // set rounded corner radius
              ),
              child: Image.asset(
                'assets/no-pic.png',
                height: 20,
                width: 20,
                color: theme_color.white,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      );
    }
    else if (user_pic != "") {
      return Stack(
        children: <Widget>[
          Container(
            margin:
            const EdgeInsets.only(left: 0, top: 15, right: 10, bottom: 0),
            padding:
            const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
            height: 105,
            width: 105,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    theme_color.button_color,
                    theme_color.button_color
                  ]),
              border: Border.all(
                  color: theme_color.button_color, // set border color
                  width: 0.5), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(50.0)), // set rounded corner radius
              // make rounded corner of border
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Image.network(
                user_pic,
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                //_openFileExplorer();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: 75, top: 15, right: 10, bottom: 0),
              padding:
              const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [ theme_color.button_color,theme_color.button_color]),
                border: Border.all(
                    color: theme_color.button_color, // set border color
                    width: 0.5), // set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(30.0)), // set rounded corner radius
              ),
              child: Image.asset(
                'assets/camera.png',
                height: 20,
                width: 20,
                color: theme_color.white,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      );
    }
    else  {
      return Stack(
        children: <Widget>[
          Container(
            margin:
            const EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
            padding:
            const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
            height: 130,
            width: 130,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    theme_color.dark_green,
                    theme_color.dark_green
                  ]),
              border: Border.all(
                  color: theme_color.dark_green, // set border color
                  width: 0.2), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(75.0)), // set rounded corner radius
              // make rounded corner of border
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Image.asset(
                'assets/no-pic.png',
                height: 120,
                width: 120,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      );
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
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

  edit_profile_API(String f_first,String f_last,String f_email_con) async {

    setState(() {
      // showLoaderDialog(context);
      //_isLoading = false;
    });

    var uri = Uri.parse(Urllink.edit_profile);

    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = member_id;
    request.fields['first_name'] = f_first;
    request.fields['last_name'] = f_last;
    request.fields['email'] = f_email_con;

    if (_fileName_1 != "") {
      print("_path ::: ${_fileName_1}");
      request.files.add(await http.MultipartFile.fromPath('profile_pic', _image));
    } else {
      // request.files.add(await http.MultipartFile.fromPath('profile_pic', ""));
    }



    http.Response response =
    await http.Response.fromStream(await request.send());
    print("Result: ${response.statusCode}");

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];
    setState(() {
      // _isLoading = true;
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      if (status == "1") {
        print(json.decode(response.body));

        setState(() {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: lable_12,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.lightGreen,
              textColor: theme_color. white,
              fontSize: 15.0);
        });

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  AppDrawer(
                child: Home(),
              ),
            ));

      } else {
        setState(() {
          Navigator.pop(context);
        });
        Fluttertoast.showToast(
            msg: lable_13,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: theme_color. white,
            fontSize: 15.0);
      }
    } else {
      setState(() {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(
          msg:lable_13,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: theme_color. white,
          fontSize: 15.0);
    }
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
            title: Text("Profile"),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              SizedBox(height: 32.0),
              Container(
                padding: const EdgeInsets.only(
                    left: 0, top: 0, right: 20, bottom: 0),
                child:GestureDetector(

                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: ClipOval(
                      child:Image.asset(
                        'assets/edit-green.png',
                        height: 15,
                        width: 15,
                        // fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),

          body:
          SingleChildScrollView(
            reverse: true,
            physics: ScrollPhysics(),

            child: Stack(
              children: <Widget>[

            Column(
            children: <Widget>[
                Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 35, top: 30, right: 35, bottom: 0),
                        child: Add_Img(),
                      ),
                      Center(
                        child:Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, right: 35, bottom: 0),
                          child: Text(
                            user_fname+" "+user_lname,
                            style: TextStyle(
                            color: theme_color.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Center(
                  child:Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        left: 15, top: 20, right: 35, bottom: 0),
                    child:Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          children: [

                            WidgetSpan(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 5, top: 1, right: 5, bottom: 5),
                              child: Image.asset(
                                'assets/pincode.png',
                                height: 15,
                                width: 15,
                                fit: BoxFit.fill,
                              ),)

                            ),
                            TextSpan(
                              text: '',
                            )
                          ],
                        ),
                      ),
                  ),
                ),
                      Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Container(

                          height:77,
                          child:Row(
                            children: <Widget>[
                              Container(
                                child:Image.asset(
                                  'assets/call-icon.png',
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.fill,
                                ),

                                margin: const EdgeInsets.only(
                                    left: 20, top: 10, right: 4, bottom: 0),
                                padding: const EdgeInsets.all(15),
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                  color: theme_color.light_grey,
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
                                          'Mobile Number',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: theme_color.black,
                                            fontSize: 15,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children:<Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 5, right: 0, bottom: 5),
                                        margin: const EdgeInsets.only(
                                            left: 20, top: 0, right: 4, bottom: 0),
                                        child:
                                        Text(user_phno,
                                          style: TextStyle(
                                            color: theme_color.black,
                                            fontSize: 16,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w500,
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
                      ),

                      Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Container(

                          height:77,
                          child:Row(
                            children: <Widget>[
                              Container(
                                child:Image.asset(
                                  'assets/email.png',
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.fill,
                                ),

                                margin: const EdgeInsets.only(
                                    left: 20, top: 10, right: 4, bottom: 0),
                                padding: const EdgeInsets.all(15),
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                  color: theme_color.light_grey,
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
                                          'Email Address',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: theme_color.black,
                                            fontSize: 15,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children:<Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 5, right: 0, bottom: 5),
                                        margin: const EdgeInsets.only(
                                            left: 20, top: 0, right: 4, bottom: 0),
                                        child:
                                        Text(user_email,
                                          style: TextStyle(
                                            color: theme_color.black,
                                            fontSize: 16,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w500,
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
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Container(

                          height:77,
                          child:Row(
                            children: <Widget>[
                              Container(
                                child:Image.asset(
                                  'assets/pincode.png',
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.fill,
                                ),

                                margin: const EdgeInsets.only(
                                    left: 20, top: 10, right: 4, bottom: 0),
                                padding: const EdgeInsets.all(15),
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                  color: theme_color.light_grey,
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
                                          'Pin Code',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: theme_color.black,
                                            fontSize: 15,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children:<Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 5, right: 0, bottom: 5),
                                        margin: const EdgeInsets.only(
                                            left: 20, top: 0, right: 4, bottom: 0),
                                        child:
                                        Text(user_pincode,
                                          style: TextStyle(
                                            color: theme_color.black,
                                            fontSize: 16,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w500,
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
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 5, right: 15, bottom: 5),
                        padding: const EdgeInsets.only(
                            left: 5, top: 10, right: 5, bottom: 5),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(
                                  left: 15, top: 10, right: 10, bottom: 0),
                              child: Text(
                                'Saved Shopping List' ,
                                style: TextStyle(
                                  color: theme_color.text_color,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    height: 130,
    child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount:shopping_string.length,
    itemBuilder: (context, index) {
    return Container(
      margin:
      const EdgeInsets.only(left: 0, top: 0, right: 20, bottom: 0),

      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              theme_color.button_color,
              theme_color.button_color
            ]),
        border: Border.all(
            color: theme_color.button_color, // set border color
            width: 0.5), // set border width
        borderRadius: BorderRadius.all(
            Radius.circular(25.0)), // set rounded corner radius
        // make rounded corner of border
      ),
    width: 250,
    child: Card(
    color: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[

          Row(
         children: [
          Container(
            padding:
            const EdgeInsets.only(left: 10, top: 5, right: 2, bottom: 2),
            child: Text(shopping_string[index].list_name  , style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600,
            ),)),
          ],
          ),
          Row(

        children: [
          Container(
              padding:
              const EdgeInsets.only(left: 10, top: 5, right: 2, bottom: 2),
              child: Text(shopping_string[index].total +' Items' , style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w400,
              ),)),
        ],
      ),
      ],
      ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => list_product(shopping_string[index].shopping_list_id,shopping_string[index].list_name),
                ));
          },
          child:
          Container(
        width:50,
        height: 50,
        margin:
        const EdgeInsets.only(left: 30, top: 0, right: 20, bottom: 0),
        padding:
        const EdgeInsets.only(left: 10, top:10, right: 10, bottom: 10),

        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                theme_color.white,
                theme_color.white,
              ]),
          border: Border.all(
              color: theme_color.button_color, // set border color
              width: 0.5), // set border width
          borderRadius: BorderRadius.all(
              Radius.circular(15.0)), // set rounded corner radius
          // make rounded corner of border
        ),
        child: Image.asset(
          'assets/arrow-right.png',
          height: 10,
          width: 10,
          // fit: BoxFit.fill,
        ),
      ),
    ),

        ],
    ),

    ),
    );
    }),
    ),

                          ],
                        ),
                      ),


                    ],
                  ),

            ],
          ),
              ],
            ),
          ),
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: theme_color.background_color,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            ),
            // sets the inactive color of the `BottomNavigationBar`
            child: new BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor:theme_color.dark_green,
              currentIndex: 3,
              onTap:onTabTapped,
              items: [
                new BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  label:"Home",
                ),
                new BottomNavigationBarItem(
                  icon: new Image.asset('assets/last_order.png', height: 22),
                  label: "My orders",
                ),
                new BottomNavigationBarItem(
                  icon: new Image.asset('assets/shoping_list.png', height: 22),
                  label: "My List",
                ),

                new BottomNavigationBarItem(
                  icon: new Image.asset('assets/profile-inactive.png', height: 22),
                  label: "Profile",
                )
              ],
            ),
          ),


        ),

      ],
    );

  }
  void onTabTapped(int value) {
    setState(() {
      if (value == 0) {
         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      } else if (value == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => my_order(),
            ));
      } else if (value == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => shopping_list(),
            ));
      }
      else if (value == 3) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => setting(),
            ));
      }
    });
  }

}
