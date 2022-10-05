import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/Model/promocode.dart';
import 'package:kamya_app/add_address.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:kamya_app/product_detail.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'AppDrawer.dart';
import 'Dash.dart';
import 'Model/product.dart';
import 'Model/varient_data.dart';
import 'Urllink.dart';
import 'cart.dart';
import 'model/cart.dart';
import 'home.dart';
import 'notifications.dart';

class promocode_screen extends StatefulWidget {

  @override
  _promocode_screenState createState() => _promocode_screenState();
}
class _promocode_screenState extends State<promocode_screen> {
  int _selected_varient=0;
  final promocode = TextEditingController();

  List cartlist = [];
  List<cart_list> cart_string = [];

  List varientlist = [];
  List<varient_data> varient_string = [];


  Prefs prefs = new Prefs();
  String dropdownValue = 'Select Varient';
  List promocodelist = [];
  List<promocode_list> promocode_string = [];
//  var dropdown = List<String>.filled(6,'Select Varient', growable: true);
  var dropdown = [];
  String radioButtonItem = 'Home';
  late String status;
  int id = 1;
  int quantity=0;
  TextEditingController search_product = new TextEditingController();
  List<TextEditingController> _quantityController =  [];
  var varient_price = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_promocode();
      this.get_cart();
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
            title: Text("Select Promocode"),
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
                              left: 5, top: 3, right: 5, bottom: 0),
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
                            controller: promocode,
                            onChanged: (text) {
                              //search_selected(text);
                              Navigator.pop(context);
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Enter Promo Code',
                              border: InputBorder.none,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child:
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.pop(context);
                                    check_promocode();
                                  },
                                  child:  Container(
                                    height: 105,
                                    width: 60,
                                    padding: const EdgeInsets.only(
                                        left: 8, top: 5, right: 5, bottom: 5),
                                    alignment: Alignment.topLeft,

                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: theme_color.light_green, // set border color
                                          width: 1), // set border width
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              25.0)), // set rounded corner radius
                                      // make rounded corner of border
                                    ),
                                    child:Text('Apply'),
                                  ),

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

                Container(
                  height:MediaQuery.of(context).size.height-100,
                  width:MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 0, top:0, right: 0, bottom: 65),
                  child:ListView.builder(
                    key: UniqueKey(),
                    itemCount: promocode_string.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                   Container(
                                      width:MediaQuery.of(context).size.width-20,
                                      child: Row(
                                            children:<Widget>[
                                              SizedBox(
                                                width: 210,
                                                child:  InkWell(
                                                  /*onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => product_detail( promocode_string[index].product_id)),
                                                  );
                                                 },*/
                                                  child:
                                                  Container(
                                                    padding: const EdgeInsets.only(
                                                        left: 0, top: 10, right: 0, bottom: 5),

                                                    margin: const EdgeInsets.only(
                                                        left: 20, top:5, right: 2, bottom: 0),
                                                    child:Text(
                                                      promocode_string[index].promocode_desc,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: theme_color.black,
                                                        fontSize: 17,
                                                        //fontFamily: "Quicksand",
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(

                                                margin: EdgeInsets.only(left: 25),
                                                child :
                                                ElevatedButton(

                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(theme_color.dark_green),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.0),
                                                        side: BorderSide(
                                                          color: theme_color.dark_green,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(promocode_string[index].promocode),
                                                  onPressed: () {
                                                    copy_promocode(promocode_string[index].promocode);
                                                  },
                                                ),
                                              ),

                                            ],
                                          ),


                                    ),


                                  ],
                                ),
                                Dash(length: MediaQuery.of(context).size.width-50, dashColor:theme_color.light_grey),

                              ],
                            )

                          ],
                        ),
                      );

                    },

                  ),

                ),
              ],
            ),
          ),
        ),

      ],
    );

  }

  check_promocode() async {
    showLoaderDialog(context);
    final url = Urllink.get_promocode_data;
    String promo = promocode.text.toString();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "promocode": promo,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      String status=datauser['success'];
      if(status=='0')
        {
            setState(() {
              cartlist = datauser['data'] as List;
              String discount = datauser['data'][0] ["discount"] as String;
              String promocode = datauser['data'][0] ["promocode"] as String;

              prefs.set_discount(discount);
              prefs.set_coupon(promocode);
              print('discountt${discount}');

            });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => cart(),
                ));

            Fluttertoast.showToast(
                msg: "Promo code applied successfully.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: theme_color.light_green,
                textColor: theme_color.black,
                fontSize: 15.0);
        }
      else{
        Fluttertoast.showToast(
            msg: "Invalid Promo code.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.red,
            textColor: theme_color.black,
            fontSize: 15.0);
      }

    }
  }
  copy_promocode(String promo){
    print(promo);
    setState(() {
      promocode.text=promo;
    });
  }

  void _addQuantity(int index){
    setState(() {
      int s = int.parse(_quantityController[index].text);
      s++;
      _quantityController[index].text = '$s';
    });
    // update_total();
  }

  void _removeQuantity(int index){
    setState(() {
      if(int.parse(_quantityController[index].text) > 1){
        int s = int.parse(_quantityController[index].text);
        s--;
        _quantityController[index].text = '$s';

      }else{
        quantity = 0;
      }
      // update_total();
    });
  }

  get_cart() async {
    showLoaderDialog(context);
    final url = Urllink.get_user_cart;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        cartlist = datauser['data'] as List;
        // print(cartlist);
        cart_string = cartlist.map<cart_list>(
                (json) => cart_list.fromJson(json)).toList();

      });
    }
  }
  add_to_cart(String varient_id,String product_id,int index) async {
    showLoaderDialog(context);
    final url = Urllink.add_cart;
    String qty=_quantityController[index].text;
    String user_id=await prefs.ismember_id();
    http.Response response = await http.post(Uri.parse(url),  body: {
      "varient_id": varient_id,
      "qty":qty,
      "product_id":product_id,
      "user_id":user_id

    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      //  print(datauser['data']);

      setState(() {
        //_showDialog_product(context);
        Fluttertoast.showToast(
            msg: "Product Added To Cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);
      });


    }
    else{
      Navigator.pop(context);

    }
    get_cart();
  }





  get_promocode() async {
    print('promocalled');
    showLoaderDialog(context);
    final url = Urllink.get_promocode;
    http.Response response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      Navigator.pop(context);
      //Map<String, dynamic> datauser = json.decode(response.body);
      var datauser = jsonDecode(response.body);
      print(datauser);
      setState(() {
        promocodelist = datauser['data'] as List;
        promocode_string = promocodelist.map<promocode_list>(
                (json) => promocode_list.fromJson(json)).toList();
        //print(promocode_string[0].varientdata.varient_name.length);
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
