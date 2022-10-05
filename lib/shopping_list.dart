import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:kamya_app/Urllink.dart';
import 'package:kamya_app/list_product.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/profile.dart';
import 'package:kamya_app/setting.dart';
import 'package:kamya_app/shopping_list_product.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'package:kamya_app/view_profile.dart';
import 'package:kamya_app/wallet.dart';

import 'AppDrawer.dart';
import 'Model/cart.dart';
import 'Model/shopping_list.dart';
import 'add_shopping_list.dart';
import 'cart.dart';
import 'home.dart';
import 'login.dart';
import 'my_order.dart';

class shopping_list extends StatefulWidget {
  @override
  _shopping_listState createState() => _shopping_listState();
}

class _shopping_listState extends State<shopping_list> {

  String f_payment = "";
  Prefs prefs = new Prefs();
  String status = "";
  String profilePic = "";
  List shoppinglist = [];
  List<shopping_list_model> shopping_string = [];
  List cartlist = [];
  List<cart_list> cart_string = [];
  String empty_list='1';


  TextEditingController first_con = new TextEditingController();
  TextEditingController last_con = new TextEditingController();
  TextEditingController mobile_con = new TextEditingController();
  TextEditingController email_con = new TextEditingController();
  String _fileName_1 = "";

  late String member_id;





  @override
  void initState() {

    Future.delayed(const Duration(milliseconds: 500), () {
      get_shopping_list();
      get_cart();
    });


    super.initState();
  }
  get_cart() async {
    // showLoaderDialog(context);
    final url = Urllink.get_user_cart;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,

    });
    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        cartlist = datauser['data'] as List;
        // print(cartlist);
        cart_string = cartlist.map<cart_list>(
                (json) => cart_list.fromJson(json)).toList();

      });
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

  get_shopping_list() async {
    print('in shopping list');
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
          print('listlength${shopping_string.length}');
          if (shopping_string.length == 0)
          {
            empty_list='0';
          }

        });
      } else {
        setState(() {
          empty_list='0';

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

  search_shopping_list(String list) async {
    var url = Urllink.search_shopping_list;
    String user_id = await prefs.ismember_id();
    final response = await http.post(Uri.parse(url),
        body: {
          "user_id": user_id,
          "list": list,
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
            title: Text("Shopping List"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  Home())),
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
                  child:     CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Badge(
                      badgeContent: Text('${cart_string.length}'),
                      badgeColor: theme_color.dark_green,
                      child:  Image.asset(
                        'assets/cart.png',
                        height: 20,
                        width: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                ),
              ),

              SizedBox(height: 32.0),
              Container(
                padding: const EdgeInsets.only(
                    left: 0, top: 0, right: 20, bottom: 0),
                child:GestureDetector(

                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => add_shopping_list(),
                        ));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(Icons.add
                    ,color:theme_color.dark_green),
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
                Container(
                  height: 65,
                  margin: const EdgeInsets.only(
                      left: 0, top: 25, right: 0, bottom: 0),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Expanded(
                        child: Container(
                          height: 55,
                          margin: const EdgeInsets.only(
                              left: 25, top: 5, right: 25, bottom: 0),
                          padding: const EdgeInsets.only(
                              left: 5, top: 5, right: 5, bottom: 5),
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
                          child:TextField(
                           controller: mobile_con,
                            onChanged: (text) {
                              search_shopping_list(text);
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Search..',
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/search-blue.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              //  suffixIcon: Icon(Icons.search),
                            ),
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
                empty_list == '0' ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child:Container(
                        margin: const EdgeInsets.only(
                            left: 0, top: 30, right: 0, bottom: 0),
                        height:100,
                        width:100,
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
                          'Your shopping list is empty!',
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
                          'Make your basket happy and add products to purchase them',
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => add_shopping_list(),

                            ));

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
                          'CREATE LIST NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            //fontFamily: "Quicksand"
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                  ],
                ):

                Align(
              alignment: Alignment.center,

              child:Container(
                  margin:
                  const EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  height: MediaQuery.of(context).size.height-65,
                  width:MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount:shopping_string.length, itemBuilder: (context, index) {
                      return  Dismissible(
                        key: Key('item ${shopping_string[index]}'),
                    background: Container(
                    color: Color(0xffEB7C77),
                    child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                    Container(
                    margin: const EdgeInsets.only(
                    left: 20, top:5, right: 30, bottom: 0),
                    child: Column(children:<Widget>[
                    Center(child:Icon(Icons.delete, color: Colors.white)),
                    Center(child:Text('Cancel', style: TextStyle(color: Colors.white))),
                    ],),
                    ),

                    Row(children:<Widget>[
                    ],),


                    ],
                    ),
                    ),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                    title: const Text("Delete Confirmation"),
                    content: const Text("Are you sure you want to delete this list?"),
                    actions: <Widget>[
                    TextButton(
                    onPressed: () {
                    delete_list(shopping_string[index].shopping_list_id);
                    Navigator.of(context).pop(true);

                    },
                    child: const Text("Delete")
                    ),
                    TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                    ),
                    ],
                    );
                    },
                    );
                    },
                    onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.startToEnd) {
                    print("Add to favorite");
                    } else {
                    print('Remove item');
                    }

                    setState(() {
                    shopping_string.removeAt(index);
                    });
                    },

                    child:



                      Container(
                      margin:
                      const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
                        width:MediaQuery.of(context).size.width,

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
                            Radius.circular(22.0)), // set rounded corner radius
                        // make rounded corner of border
                      ),
                      child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => shopping_list_product(shopping_string[index].shopping_list_id,shopping_string[index].list_name),
                                        ));
                                  },
                                  child:
                                  Row(
                                  children: [
                                    Container(
                                        padding:
                                        const EdgeInsets.only(left: 20, top: 10, right: 2, bottom: 2),
                                        child: Text(shopping_string[index].list_name , style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w800,
                                        ),)),
                                  ],
                                ),
                                  ),
                                Row(
                                  children: [
                                    Container(
                                        padding:
                                        const EdgeInsets.only(left: 20, top: 10, right: 2, bottom: 12),
                                        child: Text(shopping_string[index].total+' Items' , style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w400,
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
                              child:     Container(
                                width:55,
                                height:55,
                                padding:
                                const EdgeInsets.only(left: 15, top:10, right: 15, bottom: 10),
                                margin:
                                const EdgeInsets.only(left: 0, top:5, right: 15, bottom: 5),

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
                                      Radius.circular(20.0)), // set rounded corner radius
                                  // make rounded corner of border
                                ),
                                child: Image.asset(
                                  'assets/arrow-right.png',
                                  height: 10,
                                  width: 10,
                                  // fit: BoxFit.fill,
                                ),
                              ),

                            )
                          ],
                        ),


                    ),
                    );
                  }),
                ),
            ),



              ],
            ),
          ),
          bottomNavigationBar:
          new Theme(
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
              currentIndex: 2,
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
  delete_list(String shopping_list_id) async {
    showLoaderDialog(context);
    final url = Urllink.delete_shopping_list;
    http.Response response = await http.post(Uri.parse(url),  body: {
      "shopping_list_id":shopping_list_id,

    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      print(datauser['data']);
      setState(() {
        Fluttertoast.showToast(
            msg: "Shopping List Deleted Successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>   shopping_list(),

          ));

    }
    else{
      Navigator.pop(context);

    }
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

}
