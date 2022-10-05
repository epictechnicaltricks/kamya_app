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
import 'my_address.dart';
class add_address extends StatefulWidget {
  @override
  _add_addressState createState() => _add_addressState();
}
class _add_addressState extends State<add_address> {
  Prefs prefs = new Prefs();
  List notification_list = [];
  List<Notification_list> notification_string = [];
  TextEditingController address_1 = new TextEditingController();
  TextEditingController address_2 = new TextEditingController();
  TextEditingController near_by = new TextEditingController();
  TextEditingController phone_no = new TextEditingController();
  TextEditingController pin_code = new TextEditingController();
  TextEditingController city = new TextEditingController();
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
            title: Text("Add Address"),
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

              child:Column(
                children: [
                 /* Container(
                    height: 300,
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 5, right: 15, bottom: 10),
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, right: 15, bottom: 0),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          color: theme_color.white,
                          border: Border.all(
                              color: theme_color.light_green, // set border color
                              width: 1), // set border width
                          borderRadius: BorderRadius.all(
                              Radius.circular(
                                  25.0)), // set rounded corner radius
                          // make rounded corner of border
                        ),
                        child: SearchMapPlaceWidget(
                          apiKey:'AIzaSyBfgJRCskFj93qiqYbNDwUnUJd8b-Pkj2U', // YOUR GOOGLE MAPS API KEY
                         )
                    ),
                  ),*/

                  Container(
                    height: 75,

                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 15, top: 20, right: 15, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      alignment: Alignment.topLeft,

                      decoration: BoxDecoration(
                        color: theme_color.white,
                        border: Border.all(
                            color: theme_color.light_green, // set border color
                            width: 1), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(
                                25.0)), // set rounded corner radius
                        // make rounded corner of border
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Address 1',
                        ),
                        controller: address_1,
                        style: new TextStyle(
                          fontFamily: "Roboto",
                          color: theme_color.black,
                          fontSize: 16,
                           
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 15, top: 0, right: 15, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: theme_color.white,
                        border: Border.all(
                            color: theme_color.light_green, // set border color
                            width: 1), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(
                                25.0)), // set rounded corner radius
                        // make rounded corner of border
                      ),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Address 2',
                          border: InputBorder.none,
                        ),
                        controller: address_2,
                        style: new TextStyle(
                          fontFamily: "Roboto",
                          color: theme_color.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 15, top: 0, right: 15, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: theme_color.white,
                        border: Border.all(
                            color: theme_color.light_green, // set border color
                            width: 1), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(
                                25.0)), // set rounded corner radius
                        // make rounded corner of border
                      ),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Near By',
                          border: InputBorder.none,
                        ),
                        controller: near_by,
                        style: new TextStyle(
                          fontFamily: "Roboto",
                          color: theme_color.black,
                          fontSize: 16,
                           
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 15, top: 0, right: 15, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: theme_color.white,
                        border: Border.all(
                            color: theme_color.light_green, // set border color
                            width: 1), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(
                                25.0)), // set rounded corner radius
                        // make rounded corner of border
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(hintText: 'Alternate Phone Number',
                            border: InputBorder.none,
                            counterText: ''),
                        controller: phone_no,
                        style: new TextStyle(
                          fontFamily: "Roboto",
                          color: theme_color.black,
                          fontSize: 16,

                        ),
                      ),
                    ),
                  ),
                  Container(
                  height: 55,
                    margin: const EdgeInsets.only(
                        left: 15, top: 5, right: 20, bottom: 0),
                    padding: const EdgeInsets.only(
                        left: 15, top: 0, right: 5, bottom: 0),
                    decoration: BoxDecoration(
                      color: theme_color.white,
                      border: Border.all(
                          color: theme_color.light_green, // set border color
                          width: 1), // set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              25.0)), // set rounded corner radius
                      // make rounded corner of border
                    ),
                    child:new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                            keyboardType: TextInputType.number,
                            maxLength: 7,
                            controller: pin_code,
                            decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Pincode',
                                border: InputBorder.none,
                             )
                        ),
                      ),
                      SizedBox(width: 20.0,),
                      new Flexible(
                        child: new TextField(
                            controller: city,
                            decoration: InputDecoration(
                                hintText: 'City',
                                border: InputBorder.none,
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Container(
                         margin: const EdgeInsets.only(
                             left: 25, top: 15, right: 20, bottom: 0),
                         child: Text(

                           'Type of Address',
                           style: new TextStyle(fontSize: 17.0),
                         ),
                       ),
                     ),
                   ],
                  ),
                   Container(
                  height: 35,
                  margin: const EdgeInsets.only(
                      left: 20, top: 15, right: 20, bottom: 0),
                  child:new Row(
                    children: <Widget>[
                      Radio(
                        fillColor: MaterialStateColor.resolveWith((states) => theme_color.light_green),
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Home';
                            id = 1;
                          });
                        },
                      ),
                      Text(
                        'Home',
                        style: new TextStyle(fontSize: 17.0),
                      ),

                      Radio(
                        fillColor: MaterialStateColor.resolveWith((states) => theme_color.light_green),
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Office';
                            id = 2;
                          });
                        },
                      ),
                      Text(
                        'Office',
                        style: new TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      Radio(
                        fillColor: MaterialStateColor.resolveWith((states) => theme_color.light_green),
                        value: 3,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Other';
                            id = 3;
                          });
                        },
                      ),
                      Text(
                        'Other',
                        style: new TextStyle(fontSize: 17.0),
                      ),

                    ],
                  ),
                ),

                ],
              )
            ),

          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              String address1 = address_1.text;
              String address2 = address_2.text;
              String nearby = near_by.text;
              String phoneno = phone_no.text;
              String pincode = pin_code.text;
              String city_name = city.text;
              String type = radioButtonItem;

              if(address1=='')
              {
                Fluttertoast.showToast(
                    msg: "Please Enter Address Line 1",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: theme_color.black,
                    fontSize: 15.0);

              }
              else if(address2=='')
              {
                Fluttertoast.showToast(
                    msg: "Please Enter Address Line 2",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: theme_color.black,
                    fontSize: 15.0);

              } else if(nearby=='')
              {
                Fluttertoast.showToast(
                    msg: "Please Enter Near By",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: theme_color.black,
                    fontSize: 15.0);

              } else if(phoneno=='')
              {
                Fluttertoast.showToast(
                    msg: "Please Enter Phone No",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: theme_color.black,
                    fontSize: 15.0);

              }
              else if(pincode=='')
              {
                Fluttertoast.showToast(
                    msg: "Please Enter Pincode",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: theme_color.black,
                    fontSize: 15.0);

              }
              else if(city_name=='')
              {
                Fluttertoast.showToast(
                    msg: "Please Enter City Name",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: theme_color.black,
                    fontSize: 15.0);

              }
              else if(type=='')
              {
                Fluttertoast.showToast(
                    msg: "Please Select Address Type",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: theme_color.black,
                    fontSize: 15.0);

              }
              else{

                add_address(address1,address2,nearby,phoneno,pincode,city_name,type);
              }

            },
            child:Container(
              alignment: Alignment.center,
              height: 60,
              margin: const EdgeInsets.only(
                  left: 25,
                  top: 10,
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
                'ADD NEW ADDRESS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        ),
      ],
    );
  }
  add_address(address1,address2,nearby,phoneno,pincode,city_name,type) async {
    var url = Urllink.add_address;
    String user_id = await prefs.ismember_id();
    final response = await http.post(Uri.parse(url),
        body: {
          "user_id": user_id,
          "address_1": address1,
          "address_2": address2,
          "near_by": nearby,
          "phone_no": phoneno,
          "pin_code": pincode,
          "city": city_name,
          "type": type
        });

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          Fluttertoast.showToast(
              msg: "Address added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);


        });
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: datauser['message'],
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
            builder: (context) =>my_address()
          ));

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
}
