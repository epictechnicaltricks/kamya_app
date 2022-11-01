import 'dart:math';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/add_address.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:kamya_app/setting.dart';
import 'package:kamya_app/shopping_list.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'package:kamya_app/view_profile.dart';
import 'AppDrawer.dart';
import 'Model/wallet.dart';
import 'Urllink.dart';
import 'home.dart';
class wallet extends StatefulWidget {
  @override
  _walletState createState() => _walletState();
}
class _walletState extends State<wallet> {
  TextEditingController _textFieldController = new TextEditingController();

  List walletlist = [];
  List<wallet_list> wallet_string = [];
  String radioButtonItem = 'Home';
  late String status;
  late String wallet_bal;
  int id = 1;
  Prefs prefs = new Prefs();
  String stage = "TEST";
  String orderId = "101";
  String orderAmount = '';
  String tokenData = "TOKEN_DATA";
  String customerName = "Kaniatech developer";
  String orderNote = "kamya order";
  String orderCurrency = "INR";
  String appId = "1619463e851c389652af537723649161";
  String customerPhone = "9999999999";
  String customerEmail = "sample@gmail.com";
  String notifyUrl = Urllink.Main_Link + "cashfree_order/11";
  String amount='0';
  String payment_status='';
  String transaction_id='';
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_wallet();
    });

  }
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Amount'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Please Enter Amount"),
            ),
            actions: <Widget>[
              TextButton(

 style: TextButton.styleFrom(
    primary: Colors.red, // foreground
    
  ),


                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(

 style: TextButton.styleFrom(
    primary: Colors.green, // foreground
    
  ),


              
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    amount=_textFieldController.text;

                    Navigator.pop(context);
                  });
                  openCheckout();
                },
              ),
            ],
          );
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
            title: Text("Wallet"),
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
                    _displayTextInputDialog(context);
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
            body:     Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child:Container(
                            child:Image.asset(
                              'assets/wallet.png',
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                            ),

                            margin: const EdgeInsets.only(
                                left: 20, top: 15, right: 4, bottom: 0),
                            padding: const EdgeInsets.all(30),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(60.0)),
                              color: theme_color.dark_green,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],),
                          ),

                        ),
                        Center(
                          child:
                        Container(
                          margin: const EdgeInsets.only(
                              left: 0, top: 5, right: 0, bottom: 0),
                          child:Text(
                            '₹ '+wallet_bal,
                            style: TextStyle(
                              color: theme_color.black,
                              fontSize: 25,
                              //fontFamily: "Quicksand",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ),
                        Center(
                          child:Text(
                            'Current Balance',
                            style: TextStyle(
                              color: theme_color.text_color,
                              fontSize: 18,
                              //fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.topLeft,
            child:
            Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 0, bottom: 12),

              margin: const EdgeInsets.only(
                  left: 0, top:30, right: 0, bottom: 0),

              height:60,
              width:MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey),
                      bottom: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                  ),
                  child:Text(
                   'Transactions',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: theme_color.button_color,
                      fontSize: 20,
                      //fontFamily: "Quicksand",
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                ),
          ),
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Container(
                    height:MediaQuery.of(context).size.height-485,
                    width:MediaQuery.of(context).size.width,
                    child:  ListView.builder(
                      itemCount: wallet_string.length,
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
                            height:77,
                            child:Row(
                              children: <Widget>[
                                Container(
                                  child:Image.asset(
                                    'assets/cash.png',
                                    height: 15,
                                    width: 15,
                                    fit: BoxFit.fill,
                                  ),

                                  margin: const EdgeInsets.only(
                                      left: 20, top: 0, right: 4, bottom: 0),
                                  padding: const EdgeInsets.all(15),
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                    color: Colors.white,
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
                                    Container(
                                          padding: const EdgeInsets.only(
                                              left: 0, top: 10, right: 0, bottom: 5),

                                          margin: const EdgeInsets.only(
                                              left: 20, top:0, right: 4, bottom: 0),
                                          child:Text(
                                            wallet_string[index].wallet_desc,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: theme_color.black,
                                              fontSize: 18,
                                              //fontFamily: "Quicksand",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),



                                     Container(
                                          padding: const EdgeInsets.only(
                                              left: 0, top: 5, right: 0, bottom: 5),
                                          margin: const EdgeInsets.only(
                                              left: 20, top: 0, right: 4, bottom: 0),
                                          child:
                                                Text(
                                                    wallet_string[index].wallet_date,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    style: TextStyle(color: Colors.black,),
                                                  ),
                                        ),


                                  ],
                                ),
                                SizedBox(width: 20,),
                                Text(
                                    wallet_string[index].credit_debit+'₹ '+wallet_string[index].wallet_amount,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: theme_color.button_color,
                                      fontSize: 20,
                                      //fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),



                              ],
                            ),

                          ),
                        );
                      },
                    ),
                  ),
                ),




    ],



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
  openCheckout() async {
    final url = Urllink.cashfree_token;
    String user_id = await prefs.ismember_id();
    Random random = new Random();
    int randomNumber = random.nextInt(1000000);
    orderId = "KAMYA_${randomNumber}";
    http.Response response = await http.post(Uri.parse(url), body: {
      "order_id": orderId,
      "order_amount": amount,

    });
    if (response.statusCode == 200) {
      //  Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      String token = datauser['cftoken'];
      String user_phone = await prefs.isphone_num();
      print('mobile_number${user_phone}');
      String user_name = await prefs.isuser_name();

      Map<String, dynamic> inputParams = {
        "orderId": orderId,
        "orderAmount": amount,
        "customerName": user_name,
        "orderNote": orderNote,
        "orderCurrency": orderCurrency,
        "appId": appId,
        "customerPhone": user_phone,
        "customerEmail": customerEmail,
        "stage": stage,
        "tokenData": token,
        "color1": "#FFFFFF",
        "color2": "#000000",
        "notifyUrl": notifyUrl
      };
      CashfreePGSDK.doPayment(inputParams).then((value) {
        print(value);
        print(value!['txStatus']);
        String ans = value!['txStatus'].toString();
        String res = value!['referenceId'].toString();
        setState(() {
          payment_status = "$ans";
          transaction_id = "${res}";
        });


        if (ans == 'SUCCESS') {
          place_order();
        }
        else {
          Fluttertoast.showToast(
              msg: "Something went wrong.please try again.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);
        }
        //Do something with the result
      });
    }
  }


  place_order() async {


    final url = Urllink.add_to_wallet;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,
       "transaction_id": transaction_id,
       "payment_status": payment_status,
       'amount':'${amount}',

    });
    print(response.body);
    if (response.statusCode == 200) {
      //Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);

      setState(() {
        if(datauser["success"]=='0') {
          Fluttertoast.showToast(
              msg: datauser['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => wallet(),
              ));
        }
        else{
          Fluttertoast.showToast(
              msg: datauser['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.red,
              textColor: theme_color.black,
              fontSize: 15.0);

        }
      });
    }

  }

  get_wallet() async {
    showLoaderDialog(context);
    final url = Urllink.get_wallet;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        wallet_bal=datauser['wallet'];
        walletlist = datauser['data'] as List;
        wallet_string = walletlist.map<wallet_list>(
                (json) => wallet_list.fromJson(json)).toList();
      });

    }
    return wallet_bal;
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
              builder: (context) => wallet(),
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
