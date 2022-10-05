import 'dart:convert';
import 'dart:io';
//import 'package:flutter_dash/flutter_dash.dart';
import 'package:kamya_app/Urllink.dart';
import 'package:kamya_app/list_product.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/profile.dart';
import 'package:kamya_app/return_policy.dart';
import 'package:kamya_app/shopping_list.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'package:kamya_app/view_profile.dart';
import 'package:kamya_app/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppDrawer.dart';
import 'Dash.dart';
import 'Model/shopping_list.dart';
import 'Policy.dart';
import 'Terms.dart';
import 'add_shopping_list.dart';
import 'cart.dart';
import 'home.dart';
import 'login.dart';
import 'my_address.dart';
import 'my_order.dart';
import 'notifications.dart';

class setting extends StatefulWidget {
  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {

  String f_payment = "";
  String selected='';
  Prefs prefs = new Prefs();
  String status = "";
  String profilePic = "";
  List shoppinglist = [];
  List<shopping_list_model> shopping_string = [];

  TextEditingController first_con = new TextEditingController();
  TextEditingController last_con = new TextEditingController();
  TextEditingController mobile_con = new TextEditingController();
  TextEditingController email_con = new TextEditingController();
  String _fileName_1 = "";

  late String member_id;





  @override
  void initState() {
    get_shopping_list();
    super.initState();
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
            title: Text("Settings"),
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
                          builder: (context) => cart(),
                        ));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Image.asset(
                      'assets/cart.png',
                      height: 20,
                      width: 20,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),


            ],
          ),

          body:
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,

                  child:Container(
                    margin:
                    const EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 0),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    height: 670,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.supervised_user_circle, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  my_order()
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 10, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'first' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.shopping_cart, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'My Orders',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => my_address(),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'four' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.checklist , color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'My Addresses',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Notifications(),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'two' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.notifications, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'Notifications',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => wallet(),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'six' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.account_balance_wallet, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'Wallet',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => terms(),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'six' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.settings, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => policy(),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'six' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.privacy_tip, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => return_policy(),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'six' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.privacy_tip, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'Return Policy',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                        InkWell(
                          onTap: open_whatsapp,

                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'six' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.support_agent, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'Helpline',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                        InkWell(
                          onTap: () {
                            logout();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 5, right: 4, bottom: 0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: selected == 'five' ?<Color>[
                                    theme_color.button_color,
                                    Colors.transparent
                                  ] : <Color>[
                                    Colors.transparent,
                                    Colors.transparent
                                  ],

                                  stops: [
                                    0.0,
                                    0.7
                                  ]
                              ),
                            ),


                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon( Icons.logout, color: theme_color.button_color),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child:Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: theme_color.button_color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dash(length: 350, dashColor:theme_color.light_grey),

                      ],
                    ),
                  ),
                ),



              ],
            ),
          ),
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
                canvasColor: theme_color.background_color,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                textTheme: Theme
                    .of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.yellow))),
            // sets the inactive color of the `BottomNavigationBar`
            child: new BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 3,
              onTap:onTabTapped,
              unselectedItemColor: theme_color.light_grey,
              selectedItemColor: theme_color.dark_green,

              items: [
                new BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  label: "Home",
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
                  label: "My Accounts",
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
              builder: (context) =>  AppDrawer(
                child: Home(),
              ),
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
  logout() async {

    final pref = await SharedPreferences.getInstance();
    await pref.clear();

  }
  Future open_whatsapp() async{
    var whatsappUrl =
        "whatsapp://send?phone=917815073808";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
        "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");

    var whatsappURl_android =
        "whatsapp://send?phone=917815073808&text=";
    var whatappURL_ios =
        "https://wa.me/917815073808?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios,
            forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                new Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                new Text("whatsapp not installed")));
      }
    }



  }


}
