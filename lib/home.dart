import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kamya_app/my_address.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:kamya_app/product.dart';
import 'package:kamya_app/profile.dart';
import 'package:kamya_app/search.dart';
import 'package:kamya_app/setting.dart';
import 'package:kamya_app/shopping_list.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'package:kamya_app/view_profile.dart';
import 'package:kamya_app/wallet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Model/banner.dart';
import 'Model/cart.dart';
import 'Model/category.dart';
import 'Urllink.dart';
import 'add_address.dart';
import 'cart.dart';
import 'city.dart';
import 'failed.dart';
import 'my_order.dart';
import 'notifications.dart';
import 'AppDrawer.dart';


class Home extends StatefulWidget {
//  final AppBar appBar;
 // Home() : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  List cartlist = [];
  List<cart_list> cart_string = [];

  List category_list = [];
  List<Category> category_string = [];
  List banner_list = [];
  List<Banners> banner_string = [];
  Prefs prefs = new Prefs();
  String username='Guest';
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), ()
    {
      get_banner();
      get_cart();
    });
  }
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    AppBar appBar =AppBar(
      title: Text('Kamya'),
     /* leading: Builder(
        builder: (BuildContext appBarContext) {
          return IconButton(
              onPressed: () {
                AppDrawer.of(appBarContext).toggle();
              },
              icon: Icon(Icons.menu)
          );
        },
      ),*/
    );
    return Stack(
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
        key: scaffoldKey,
          drawer: AppDrawer(
            child: Home(),
          ),
          backgroundColor: Colors.transparent,
          // <-- SCAFFOLD WITH TRANSPARENT BG
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            // <-- SCAFFOLD WITH TRANSPARENT BG
            elevation: 0,

           /* leading: Builder(
              builder: (BuildContext appBarContext) {
                return IconButton(
                    onPressed: () {

                      AppDrawer.of(appBarContext).toggle();
                    },
                    icon: Icon(Icons.menu)
                );
              },
            ),*/

            automaticallyImplyLeading: false,
            title: Text("Hi,${username}"),
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
                  child:
                  CircleAvatar(
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
                          builder: (context) => Notifications(),
                        ));
                  },
                  child: CircleAvatar(
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
          body:    DoubleBack(
            message:"Press back again to close",
            child:
            WillPopScope(
              //onWillPop: () => showExitPopup(context),
              onWillPop: () async =>    exit(0),
              child:
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          //show_banner(context),
                          Container(
                            margin: EdgeInsets.all(15),
                            child: CarouselSlider.builder(
                              itemCount: banner_string.length,
                              options: CarouselOptions(
                                enlargeCenterPage: true,
                                height: 130,
                                autoPlay: false,
                                autoPlayInterval: Duration(seconds: 10),
                                reverse: false,
                                aspectRatio: 5.0,
                              ),
                              itemBuilder: (context, i, id) {
                                return GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white,
                                        )),
                                    //ClipRRect for image border radius
                                    child:
                                Image.network(

                                banner_string[i].banner_img,
                                width: 500,
                                fit: BoxFit.cover,
                                ),
                                  ),


                                );
                              },
                            ),
                          ),


                          Container(
                            child: Row(
                              children: [
                                Container(
                                  child: Text(
                                    'Categories',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: theme_color.button_color,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 220, top: 10, right: 4, bottom: 0),
                                  child:  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(iconSize: 21.0,
                                        icon: Icon(Icons.search),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => product('0'),
                                              ));
                                        }),

                                  ),
                                ),

                              ],
                            ),
                          ),

                          _buildFields(context),

                        ],
                      ),
                    ),

                    /*Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 300, top: 0, right: 0, bottom: 0),
                    child: IconButton(icon: new Image.asset(
                        'assets/whatsapp.png', height: 300, width: 300),
                        onPressed: () {}),

                  ),
                  bottom: 5,
                ),*/
                  ],
                ),

              ),
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
              selectedItemColor:theme_color.dark_green,
              currentIndex: 0,
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
       /* GestureDetector(
          onTap: open_whatsapp,
          child: Container(
            height: 70,
            width:70,
            padding: const EdgeInsets.only(left: 16),

            margin: const EdgeInsets.only(left: 326,right:16,top:700),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/whatsapp.png')
              ),

              border:  Border.all(color: Theme.of(context).accentColor),
            ),
          ),
        )*/


      ],

    );
  }
  Future open_whatsapp() async{
    var whatsappUrl =
        "whatsapp://send?phone=911234567890";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
        "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");

    var whatsappURl_android =
        "whatsapp://send?phone=911234567890&text=";
    var whatappURL_ios =
        "https://wa.me/911234567890?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
    await launch(whatappURL_ios,
    forceSafariVC: false);
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content:
    new Text("whatsapp no installed")));
    }
    } else {
    // android , web
    if (await canLaunch(whatsappURl_android)) {
    await launch(whatsappURl_android);
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content:
    new Text("whatsapp no installed")));
    }
    }



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
  get_cart() async {
    showLoaderDialog(context);
    final url = Urllink.get_user_cart;
    String user_id = await prefs.ismember_id();
    username = await prefs.isuser_name();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        cartlist = datauser['data'] as List;
        print(cartlist);
        cart_string = cartlist.map<cart_list>(
                (json) => cart_list.fromJson(json)).toList();

      });
    }
  }

  get_banner() async {
    print('in banner');
    // showLoaderDialog(context);
    final url = Urllink.get_banner;
    http.Response response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        banner_list = datauser['data'] as List;
        banner_string = banner_list.map<Banners>(
                (json) => Banners.fromJson(json)).toList();
      });
      return banner_string;
    }
  }

  get_category() async {
    // showLoaderDialog(context);
    final url = Urllink.get_category;
    http.Response response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        category_list = datauser['data'] as List;
        category_string = category_list.map<Category>(
                (json) => Category.fromJson(json)).toList();
      });
      return category_string;
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



  Widget _buildFields(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: get_category(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
              //    child: CircularProgressIndicator()
                      );
            } else {
              return Container(
                  margin: const EdgeInsets.only(
                      left: 0, top: 4, right: 4, bottom: 0),
                  child: GridView.count(
                    padding: EdgeInsets.all(20),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(category_string.length, (index) {
                      return Center(
                        child: new Column(
                          children: [
                            new Expanded(
                              child: GestureDetector(
                                onTap: () {
                                     Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    product(category_string[index].category_id)),

                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    child: new Image.network(
                                      category_string[index].category_img,
                                      height: 50,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.5,
                                    ),

                                  ),

                                ),
                              ),
                            ),
                            new Text(
                              category_string[index].category_name,
                              style: TextStyle(
                                color: theme_color.text_color,
                                fontSize: 15,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),

                      );
                    }),
                  )
              );
            }
          }
      ),
    );
  }
}
Future<bool> showExitPopup(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Do you want to exit?"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('yes selected');
                          exit(0);
                        },
                        child: Text("Yes"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade800),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('no selected');
                            Navigator.of(context).pop();
                          },
                          child:
                          Text("No", style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        );
      });
}
