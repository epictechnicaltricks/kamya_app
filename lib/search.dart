import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class search extends StatefulWidget {

  @override
  _searchState createState() => _searchState();
}
class _searchState extends State<search> {
  int _selected_varient=0;
  List cartlist = [];
  List<cart_list> cart_string = [];

  List varientlist = [];
  List<varient_data> varient_string = [];


  Prefs prefs = new Prefs();
  String dropdownValue = 'Select Varient';
  List productlist = [];
  List<product_list> product_string = [];
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
      this.get_product();
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
            title: Text("Search Products"),
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
                            controller: search_product,
                            onChanged: (text) {
                              search_selected(text);
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
                    itemCount: product_string.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 23.0),
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

                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => product_detail( product_string[index].product_id)),
                                          );

                                        },
                                        child: Container(
                                          width:85,
                                          height:95,
                                          padding: const EdgeInsets.only(left: 10, top:10, right: 5, bottom: 10),
                                          margin: const EdgeInsets.only(left: 0, top:0, right: 0, bottom: 10),

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
                                                Radius.circular(23.0)), // set rounded corner radius
                                            // make rounded corner of border
                                          ),
                                          child: Image.network(
                                            product_string[index].product_img,
                                            height: 10,
                                            width: 10,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),

                                      ),

                                      Container(
                                        width:295,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: <Widget>[
                                            Row(
                                              children:<Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      //   MaterialPageRoute(builder: (context) => product_detail( product_string[index].product_id)),
                                                      MaterialPageRoute(builder: (context) => product_detail( product_string[index].product_id)),
                                                    );



                                                  },
                                                  child:
                                                  Container(
                                                    padding: const EdgeInsets.only(
                                                        left: 0, top: 10, right: 0, bottom: 5),

                                                    margin: const EdgeInsets.only(
                                                        left: 20, top:5, right: 2, bottom: 0),
                                                    child:Text(
                                                      product_string[index].product_name,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: theme_color.black,
                                                        fontSize: 17,
                                                        //fontFamily: "Quicksand",
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),

                                            Row(
                                              children:<Widget>[
                                                GestureDetector(
                                                  onTap:(){
                                                    _product_varient(index,product_string[index].product_id);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.only(
                                                        left: 0, top: 2, right: 0, bottom: 2),
                                                    margin: const EdgeInsets.only(
                                                        left: 20, top: 0, right: 4, bottom: 0),

                                                    child:Wrap(
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      children: [
                                                        Text(dropdown[index],
                                                          style: TextStyle(color: Colors.grey,
                                                              fontSize: 15),
                                                        ), Icon(Icons.keyboard_arrow_down_outlined,
                                                          color: Colors.grey,),
                                                      ],
                                                    ),



                                                    /* Text(
                                      product_string[index].varient_name+','+ product_string[index].varient_price,
                                      style: TextStyle(color: Colors.grey,
                                      fontSize: 13),
                                    ),*/
                                                    // _product_varient(context),
                                                  ),

                                                ),
                                                Container(
                                                  width: 50,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    radius: 20,
                                                    child:  IconButton(
                                                      icon: Icon(Icons.remove,color:theme_color.light_green),
                                                      onPressed: () {
                                                        _removeQuantity(index);
                                                      },
                                                    ),
                                                  ),
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: new Border.all(
                                                      color: theme_color.light_green,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    width: 25.0,
                                                    padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                                                    child: Center(
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        decoration: new InputDecoration(
                                                          hintText: "1",
                                                          border: InputBorder.none,
                                                        ),

                                                        keyboardType: TextInputType.number,
                                                        controller: _quantityController[index],
                                                      ),
                                                    )
                                                ),
                                                Container(
                                                  width: 50,
                                                  child:  CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    radius: 20,
                                                    child:
                                                    IconButton(
                                                      icon: Icon(Icons.add,color:theme_color.light_green),
                                                      onPressed: () {
                                                        _addQuantity(index);
                                                      },
                                                    ),
                                                  ),
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: new Border.all(
                                                      color:theme_color.light_green,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),


                                              ],
                                            ),
                                            Row(
                                              children:<Widget>[
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
                                                    child: Text('Add to cart'),
                                                    onPressed: () {

                                                      add_to_cart(product_string[index].varient_id,product_string[index].product_id,index);


                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 0, top: 5, right: 0, bottom: 5),
                                                  margin: const EdgeInsets.only(
                                                      left: 20, top: 0, right: 4, bottom: 0),

                                                  child: Text(
                                                    'Rs.'+varient_price[index],
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: theme_color.button_color,
                                                      fontSize: 15,
                                                      //fontFamily: "Quicksand",
                                                      fontWeight: FontWeight.w700,
                                                    ),

                                                  ),
                                                ),



                                              ],
                                            ),
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                  Dash(length: MediaQuery.of(context).size.width-10, dashColor:theme_color.light_grey),

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




  search_selected(String product) async {
    // showLoaderDialog(context);
    final url = Urllink.search_product;
    http.Response response = await http.post(Uri.parse(url),  body: {
      "product": product,

    });
    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        productlist = datauser['data'] as List;
        product_string = productlist.map<product_list>(
                (json) => product_list.fromJson(json)).toList();
      });

    }
    set_qty();
  }
  set_qty() {
    for (var i = 0; i < product_string.length; i++) {
      _quantityController.add(new TextEditingController());
      _quantityController[i].text = '1';
      dropdown = List<String>.filled(product_string.length,product_string[i].varient_name, growable: true);

      varient_price = List<String>.filled(product_string.length,product_string[i].varient_price, growable: true);
    }
  }

  get_product() async {
    showLoaderDialog(context);
    final url = Urllink.get_all_product;
    http.Response response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      Navigator.pop(context);
      //Map<String, dynamic> datauser = json.decode(response.body);
      var datauser = jsonDecode(response.body);
      print(datauser);
      setState(() {
        productlist = datauser['data'] as List;
        product_string = productlist.map<product_list>(
                (json) => product_list.fromJson(json)).toList();
        //print(product_string[0].varientdata.varient_name.length);
      });

    }
    set_qty();
  }
  _product_varient(index,product_id) async {
    print('product_id${product_id}');
    print('product_iindex${index}');
    final url = Urllink.get_product_varient;

    http.Response response = await http.post(Uri.parse(url),  body: {
      "product_id": product_id,
    });
    Map<String, dynamic> datauser = json.decode(response.body);
    setState(() {
      varientlist = datauser['data'] as List;
      varient_string =
          varientlist.map<varient_data>((json) => varient_data.fromJson(json))
              .toList();
    });
    print(varientlist);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Varient'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.2,
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: varient_string.length,
                        itemBuilder: (BuildContext context, int i) {
                          return
                            GestureDetector(
                              onTap:(){
                                Navigator.of(context).pop();
                                setState(() {
                                  dropdown[index]=varient_string[i].varient_name;
                                  varient_price[index]=varient_string[i].varient_price;

                                });

                              },
                              child:    Container(
                                height: 50,
                                margin: EdgeInsets.only(bottom: 7),
                                padding: EdgeInsets.only(top: 12,left: 10),
                                child: Text('${varient_string[i].varient_name}-₹${varient_string[i].varient_price}'),
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



                              ),


                            );

                        }),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        );



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
