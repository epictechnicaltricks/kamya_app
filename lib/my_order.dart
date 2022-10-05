import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/Model/order_list.dart';
import 'package:kamya_app/add_address.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:kamya_app/product_detail.dart';
import 'package:kamya_app/setting.dart';
import 'package:kamya_app/shopping_list.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'package:kamya_app/view_profile.dart';
import 'AppDrawer.dart';
import 'Dash.dart';
import 'Model/product.dart';
import 'Urllink.dart';
import 'cart.dart';
import 'home.dart';
import 'notifications.dart';
import 'order_summary.dart';

class my_order extends StatefulWidget {

  @override
  _my_orderState createState() => _my_orderState();
}
class _my_orderState extends State<my_order> {
  List productlist = [];
  List<product_list> product_string = [];
  List orderlist = [];
  List<order_list_model> order_string = [];
  String radioButtonItem = 'Home';
  late String status;
  int id = 1;
  int tappedIndex=0;
  TextEditingController search_order = new TextEditingController();
  Prefs prefs = new Prefs();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_my_order();
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
            title: Text("Your Orders"),
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

              SizedBox(height: 32.0),
              Container(
                padding: const EdgeInsets.only(
                    left: 0, top: 0, right: 20, bottom: 0),
                child:GestureDetector(

                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notifications(),
                        ));
                  },
                  child:  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Image.asset(
                      'assets/bell.png',
                      height: 20,
                      width: 20,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),



            ],
          ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child:Column(
              children:[
                Container(
                  height: 65,
                  margin: const EdgeInsets.only(
                      left: 0, top: 25, right: 0, bottom: 0),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 95,
                          margin: const EdgeInsets.only(
                              left: 25, top: 5, right: 25, bottom: 5),
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
                            controller: search_order,
                            onChanged: (text) {
                              search_selected(text);
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Search Order',
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/search-blue.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              //suffixIcon: Icon(Icons.search),
                            ),
                          ),

                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 150, // <-- Your width
                      height: 40, // <-- Your height
                      child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          tappedIndex=0;
                        });
                      },
                      child: Text('All Order', style: TextStyle(color: tappedIndex == 0 ? Color(0xffFFFFFF) : Color(0xff000000)),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: tappedIndex == 0 ? Color(0xff28276B) : Color(0xffFEF2D8) ,
                          shape: StadiumBorder()),
                    ),
                    ),
                    SizedBox(
                      width: 150, // <-- Your width
                      height: 40, // <-- Your height
                      child:ElevatedButton(
                      onPressed: () {
                        setState(() {
                          tappedIndex=1;
                        });

                      },
                      child: Text('Last orders', style: TextStyle(color: tappedIndex == 1 ? Color(0xffFFFFFF) : Color(0xff000000)),
                      ),

                      style: ElevatedButton.styleFrom(
                          primary: tappedIndex == 1 ? Color(0xff28276B) : Color(0xffFEF2D8) ,
                          shape: StadiumBorder()),
                    ),
                    ),
                   ],
                ),
                Container(
                  height:MediaQuery.of(context).size.height-100,
                  width:MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 0, top: 0, right: 0, bottom: 250),

                  child:ListView.builder(
                    itemCount: order_string.length,
                    itemBuilder: (context, index) {
                      return
                        InkWell(
                          onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => order_summary( order_string[index].order_id)),
                        );

                      },
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 0, top: 10, right: 0, bottom: 0),

                              margin: const EdgeInsets.only(
                                  left: 20, top:10, right: 4, bottom: 0),
                              child:Align(
                                alignment: Alignment.centerLeft,

                                child:Text(
                                  'Order ID #KAMYA${order_string[index].order_id}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: theme_color.button_color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                              ),
                            ),


                          Row(
                            children: [
                              Container(
                                height:35,
                                padding: const EdgeInsets.only(left: 20, top:3, right: 5, bottom: 3),
                                child:Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5, top:0, right: 0, bottom: 0),
                                      child:Text(
                                        '${order_string[index].order_status}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                              ),
                            ],
                          ),
                          Dash(length: 350, dashColor:theme_color.light_grey),
                        ],
                      ),
                        );

                    },

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
               ),
            // sets the inactive color of the `BottomNavigationBar`
            child: new BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor:theme_color.dark_green,
              currentIndex: 1,
              onTap:onTabTapped,
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


  search_selected(String order) async {
    // showLoaderDialog(context);
    final url = Urllink.search_order;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "order_id": order,
      "user_id": user_id,

    });
    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        orderlist = datauser['data'] as List;
        order_string = orderlist.map<order_list_model>(
                (json) => order_list_model.fromJson(json)).toList();
      });

    }
  }

  get_my_order() async {
   // showLoaderDialog(context);
    final url = Urllink.get_my_order;
    String user_id = await prefs.ismember_id();
    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,

    });
    if (response.statusCode == 200) {
      //Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        orderlist = datauser['data'] as List;
        order_string = orderlist.map<order_list_model>(
                (json) => order_list_model.fromJson(json)).toList();
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
