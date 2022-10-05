import 'package:flutter/material.dart';
import 'package:kamya_app/my_address.dart';
import 'package:kamya_app/profile.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:kamya_app/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';
import 'my_order.dart';
import 'notifications.dart';

class AppDrawer extends StatefulWidget {
  final Widget child;
  AppDrawer({key, required this.child}) : super(key: key);

  static _AppDrawerState? of(BuildContext context) => context.findAncestorStateOfType<_AppDrawerState>();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with SingleTickerProviderStateMixin {
  static Duration duration = Duration(milliseconds: 300);
  late AnimationController _controller;
  static const double maxSlide = 255;
  static const dragRightStartVal = 60;
  static const dragLeftStartVal = maxSlide - 20;
  static bool shouldDrag = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: _AppDrawerState.duration);
    super.initState();
  }

  void close() => _controller.reverse();

  void open () => _controller.forward();

  void toggle () {
    if (_controller.isCompleted) {
      close();
    } else {
      open();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails startDetails) {
    bool isDraggingFromLeft = _controller.isDismissed && startDetails.globalPosition.dx < dragRightStartVal;
    bool isDraggingFromRight = _controller.isCompleted && startDetails.globalPosition.dx > dragLeftStartVal;
    shouldDrag = isDraggingFromLeft || isDraggingFromRight;
  }

  void _onDragUpdate(DragUpdateDetails updateDetails) {
    if (shouldDrag == false) {
      return;
    }
    double delta = updateDetails.primaryDelta! / maxSlide;
    _controller.value += delta;
  }

  void _onDragEnd(DragEndDetails dragEndDetails) {
    if (_controller.isDismissed || _controller.isCompleted) {
      return;
    }

    double _kMinFlingVelocity = 365.0;
    double dragVelocity = dragEndDetails.velocity.pixelsPerSecond.dx.abs();

    if (dragVelocity >= _kMinFlingVelocity) {
      double visualVelocityInPx = dragEndDetails.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;
      _controller.fling(velocity: visualVelocityInPx);
    } else if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          double animationVal = _controller.value;
          double translateVal = animationVal * maxSlide;
          double scaleVal = 1 - (animationVal *  0.3);
          return Stack(
            children: <Widget>[
              CustomDrawer(),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..translate(translateVal)
                  ..scale(scaleVal),
                child: GestureDetector(
                  onTap: () {
                    if (_controller.isCompleted) {
                      close();
                    }
                  },
                  child: widget.child
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  AppBar appBar =AppBar(
    title: Text('Kamya'),
    leading: Builder(
      builder: (BuildContext appBarContext) {
        return IconButton(
            onPressed: () {
              AppDrawer.of(appBarContext)?.toggle();
            },
            icon: Icon(Icons.menu)
        );
      },
    ),
  );
  String selected='';
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Theme(
          data: ThemeData(
            brightness: Brightness.dark,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Expanded(flex: 1,
            child:
                  Container(
                         decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/menu_bg.jpg"), // <-- BACKGROUND IMAGE
                              fit: BoxFit.cover,
                            ),
                          ),

                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              _createHeader(),
                              InkWell(
                                onTap: () {

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  AppDrawer(
                                          child: Home(),
                                        )
                                      ));
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[
                                        theme_color.button_color,
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
                                        Icon( Icons.home, color: Colors.white),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:Text(
                                            'Home',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  selected='first';
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
                                        Icon( Icons.shopping_cart, color: Colors.black),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:Text(
                                            'My Order',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  selected='two';
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
                                        Icon( Icons.notifications, color: Colors.black),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:Text(
                                            'Notifications',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  selected='four';
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
                                        Icon( Icons.checklist , color: Colors.black),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:Text(
                                            'My Addresses',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  selected='three';
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
                                        colors: selected == 'three' ?<Color>[
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
                                        Icon( Icons.supervised_user_circle, color: Colors.black),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:Text(
                                            'Profile',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),


                              InkWell(
                                onTap: () {
                                  selected='six';
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
                                        Icon( Icons.account_balance_wallet, color: Colors.black),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:Text(
                                            'Wallet',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  logout();
                                  selected='five';
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
                                        Icon( Icons.logout, color: Colors.red),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:Text(
                                            'Logout',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

            ),



            ],
    ),
    ),
      ),
    );
  }
  Widget _createHeader() {
    return DrawerHeader(

        child: Stack(children: <Widget>[
          Positioned(
              top: 28.0,
              left: 16.0,
              child: Text("Main Menu",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }
  Widget _createDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),

      onTap: onTap,
    );
  }
    logout() async {

    final pref = await SharedPreferences.getInstance();
    await pref.clear();

  }
}
