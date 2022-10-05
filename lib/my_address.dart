import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
class my_address extends StatefulWidget {
  @override
  _my_addressState createState() => _my_addressState();
}
class _my_addressState extends State<my_address> {
  List addresslist = [];
  List<address_list> address_string = [];
  String radioButtonItem = 'Home';
  late String status;
  int id = 1;
  Prefs prefs = new Prefs();
 bool show_button=false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_my_address();
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
            title: Text("Address"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home())),
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
                        builder: (context) => add_address(),
                      ));
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.add),
                ),
              ),
          ),


        ],
    ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              height:MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,

              child: address_string.length == 0
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:Container(
                      margin: const EdgeInsets.only(
                          left: 0, top: 200, right: 0, bottom: 0),
                      height:120,
                      width:120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/shopping-list-active.png"), // <-- BACKGROUND IMAGE
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child:Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          left: 10, top:20, right: 10, bottom: 10),
                      child: Text(
                        'No Address Found!',
                        style: TextStyle(
                          color: theme_color.button_color,
                          fontSize: 21,
                          //fontFamily: "Quicksand"
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
                        'No Addresses have been added yet. Please add an address.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme_color.text_color,
                          fontSize: 18,
                          //fontFamily: "Quicksand"
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                ],
              )

                  : ListView.builder(
                itemCount: address_string.length,
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
                        height: 130,
                        margin:
                        const EdgeInsets.only(left: 0, top: 25, right: 0, bottom: 0),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Row(
                          children: <Widget>[

                           /* Radio(
                              fillColor: MaterialStateColor.resolveWith((
                                  states) => theme_color.light_green),
                              value: address_string[index].addr_id,
                              groupValue: id,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem =
                                      address_string[index].addr_id;
                                  id = 1;
                                });
                              },
                            ),*/

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 0,
                                          top: 10,
                                          right: 0,
                                          bottom: 5),

                                      margin: const EdgeInsets.only(
                                          left: 20,
                                          top: 10,
                                          right: 4,
                                          bottom: 0),
                                      child: Text(
                                        address_string[index].addr_type,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: theme_color.black,
                                          fontSize: 20,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showAlertDialog(context, address_string[index].addr_id);
                                     },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 200,
                                            top: 25,
                                            right: 0,
                                            bottom: 0),
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/delete-red.png"),
                                            // <-- BACKGROUND IMAGE
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 0, right: 0, bottom: 5),

                                      margin: const EdgeInsets.only(
                                          left: 20,
                                          top: 0,
                                          right: 4,
                                          bottom: 0),
                                      child: Text(
                                        address_string[index].addr_address_1,
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

                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 5, right: 0, bottom: 5),
                                      margin: const EdgeInsets.only(
                                          left: 20,
                                          top: 0,
                                          right: 4,
                                          bottom: 0),

                                      child:
                                      Text(
                                        address_string[index].addr_address_2 +
                                            ',' +
                                            address_string[index].addr_city,
                                        style: TextStyle(color: Colors.black,),
                                      ),
                                    ),


                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 5, right: 0, bottom: 5),
                                      margin: const EdgeInsets.only(
                                          left: 20,
                                          top: 0,
                                          right: 4,
                                          bottom: 0),
                                      child: Text(
                                        //'Mobile:'+address_string[index]?.addr_phone,
                                        'Mobile:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: theme_color.black,
                                          fontSize: 15,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 5, right: 0, bottom: 5),
                                      margin: const EdgeInsets.only(
                                          left: 5, top: 0, right: 4, bottom: 0),
                                      child: Text(
                                        //'Mobile:'+address_string[index]?.addr_phone,
                                        address_string[index].addr_phone,
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
           /* bottomNavigationBar:
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

            ),*/
            ),

      ],
    );

  }
  delete_address(addr_id) async {
    print(addr_id);
    var url = Urllink.delete_address;
    final response = await http.post(Uri.parse(url),
        body: {
          "addr_id": addr_id,
          });

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          Fluttertoast.showToast(
              msg: "Address deleted successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);


        });
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: "Something went wrong.",
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
            builder: (context) => my_address(),
          ));

    }
  }

  get_my_address() async {
    showLoaderDialog(context);
    final url = Urllink.get_my_address;
    String user_id = await prefs.ismember_id();
    http.Response response = await http.post(Uri.parse(url),  body: {
    "user_id": user_id,

    });
      print(user_id) ;
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        addresslist = datauser['data'] as List;
        address_string = addresslist.map<address_list>(
                (json) => address_list.fromJson(json)).toList();
        if(address_string.length>0)
          {
            show_button=true;
          }
      });


    }
  }
  showAlertDialog(BuildContext context,String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        delete_address(id);

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text("You won't be able to revert it."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
