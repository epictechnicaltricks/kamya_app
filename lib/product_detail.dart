import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/add_address.dart';
import 'package:kamya_app/prefs_file.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'AppDrawer.dart';
import 'Model/banner.dart';
import 'Model/product.dart';
import 'Model/product_detail.dart';
import 'Model/shopping_list.dart';
import 'Model/varient_data.dart';
import 'Urllink.dart';
import 'cart.dart';
import 'Model/cart.dart';
import 'home.dart';
import 'notifications.dart';

class product_detail extends StatefulWidget {
  String product_id;
  product_detail(this.product_id);

  @override
  _product_detailState createState() => _product_detailState();
}

class _product_detailState extends State<product_detail> {
  List productlist = [];
  List<product_detail_list> product_string = [];
  List cartlist = [];
  List<cart_list> cart_string = [];
  TextEditingController _quantityController = new TextEditingController();
  int quantity = 0;

  List varientlist = [];
  List<varient_data> varient_string = [];

  String radioButtonItem = 'Home';
  late String status;
  int id = 1;
  bool varient_selected = false;
  int tappedIndex = 0;
  late int _dotindicatoR;
  Color qty_color_minus = Colors.transparent;
  Color qty_color_plus = Colors.transparent;
  Color qty_icon_color_minus = theme_color.dark_green;
  Color qty_icon_color_plus = theme_color.dark_green;

  List banner_list = [];
  List<Banners> banner_string = [];
  TextEditingController search_product = new TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  String promo_code = '';
  String varient_price = '';
  String varient_status = '';
  String varient_mrp = '';
  String selected_varient_id = '';
  String product_name = '';
  String product_desc = '';
  String product_status = '';
  bool out_of_stock = false;
  Prefs prefs = new Prefs();
  List shoppinglist = [];
  List<shopping_list_model> shopping_string = [];
  List<String> userChecked = [];
  Color varient_box = Color(0xffD6C9AE);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_product_detail(widget.product_id);
      get_shopping_list();
      get_cart();
      _quantityController.text = '1';
      // this.get_banner();
    });
  }

  get_cart() async {
    showLoaderDialog(context);
    final url = Urllink.get_user_cart;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        cartlist = datauser['data'] as List;
        cart_string = cartlist
            .map<cart_list>((json) => cart_list.fromJson(json))
            .toList();
      });
    }
  }

  get_shopping_list() async {
    var url = Urllink.get_shopping_list;
    String user_id = await prefs.ismember_id();
    final response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
    });

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          shoppinglist = datauser['data'] as List;
          shopping_string = shoppinglist
              .map<shopping_list_model>(
                  (json) => shopping_list_model.fromJson(json))
              .toList();
        });
      } else {
        setState(() {});
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

  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
      });
    } else {
      setState(() {
        userChecked.remove(dataName);
      });
    }
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          actions: <Widget>[
            new CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop('Cancel');
              },
              child: new Text('Cancel'),
            ),
            new CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop('Accept');
              },
              child: new Text('Accept'),
            ),
          ],
          content: new SingleChildScrollView(
            child: new Material(
              child: new Container(
                height: 200,
                child: ListView.builder(
                    itemCount: shopping_string.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                          title: Text(shopping_string[i].list_name),
                          leading: Checkbox(
                            value: userChecked
                                .contains(shopping_string[i].shopping_list_id),
                            onChanged: (val) {
                              _onSelected(
                                  val!, shopping_string[i].shopping_list_id);
                            },
                          ));
                    }),
              ),
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  /* _showDialog(context) async{

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          // title: new Text("Alert!!"),
          content:
          Container(
          width:300,
          height: 340,
          child:Column(
            children: <Widget>[
          Container(
          margin: const EdgeInsets.only(
              left: 0, top: 1, right: 0, bottom: 0),
          height:40,
            child:Text(
              'Add Item To Shopping List',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
                margin: const EdgeInsets.only(
                    left: 0, top: 1, right: 0, bottom: 0),
                height:200,
               child: ListView.builder(
                   itemCount: shopping_string.length,
                   itemBuilder: (context, i) {
                     return ListTile(
                         title: Text(
                             shopping_string[i].list_name),
                         leading:Checkbox(
                     value: userChecked.contains(shopping_string[i].shopping_list_id),
                     onChanged: (val) {
                     _onSelected(val, shopping_string[i].shopping_list_id);
                     },
                     )
                     );
                   }),
              ),
              GestureDetector(
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  AppDrawer(
                          child: Home(),
                        ),
                      ));


                },child:Container(
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
                  'Add To List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ),
            ],
          ),
          ),

        );
      },
    );
  }*/
  void _showDialog_success(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          // title: new Text("Alert!!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.only(left: 0, top: 1, right: 0, bottom: 0),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/product-list-success.png"), // <-- BACKGROUND IMAGE
                  ),
                ),
              ),
              Container(
                  child: Text(
                'Item Successfully added to shopping list',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              )),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppDrawer(
                          child: Home(),
                        ),
                      ));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  margin: const EdgeInsets.only(
                      left: 25, top: 20, right: 20, bottom: 10),
                  padding: const EdgeInsets.only(
                      left: 5, top: 10, right: 5, bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme_color.button_color,
                          theme_color.button_color
                        ]),
                    border: Border.all(
                        color:
                            theme_color.texbox_background, // set border color
                        width: 0.5), // set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(30.0)), // set rounded corner radius
                    // make rounded corner of border
                  ),
                  child: Text(
                    'CONTINUE SHOPPING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // <-- STACK AS THE SCAFFOLD PARENT
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
            backgroundColor:
                Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
            appBar: AppBar(
              centerTitle: false,
              backgroundColor:
                  Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
              elevation: 0,
              // automaticallyImplyLeading: false,
              title: Text("Products"),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: <Widget>[
                SizedBox(height: 32.0),
                Container(
                  padding: const EdgeInsets.only(
                      left: 0, top: 0, right: 20, bottom: 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => cart(),
                          ));
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: Badge(
                        badgeContent: Text('${cart_string.length}'),
                        badgeColor: theme_color.dark_green,
                        child: Image.asset(
                          'assets/cart-icon-white.png',
                          height: 20,
                          width: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    child: CarouselSlider.builder(
                      itemCount: product_string.length,
                      options: CarouselOptions(
                        enlargeCenterPage: false,
                        height: 300,
                        autoPlay: false,
                        reverse: false,
                        viewportFraction: 1,
                        aspectRatio: 5.0,
                      ),
                      itemBuilder: (context, i, id) {
                        //for onTap to redirect to another screen
                        return GestureDetector(
                          child: Container(
                            child: ClipRRect(
                              child: Image.network(
                                product_string[i].product_img,
                                width: 500,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            var url = product_string[i].product_img;
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: product_string.length,
                        itemBuilder: (context, i) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _dotindicatoR == i
                                  ? Color(0xff01a8dd)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0, left: 20.0),
                      child: Text(product_name, style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 20.0, right: 20.0),
                      child: Text(product_desc,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 16, color: theme_color.text_color)),
                    ),
                  ),
                  Container(
                    height: 35,
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: product_string.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            width: 85, // <-- Your width
                            height: 5, // <-- Your height
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  varient_selected = true;
                                  varient_box = Color(0xff28276C);
                                  tappedIndex = index;
                                  get_varient_data(
                                      product_string[index].product_varient_id);
                                });
                              },
                              child: Text(product_string[index].varient_name),
                              style: ElevatedButton.styleFrom(
                                  primary: tappedIndex == index
                                      ? Color(0xff28276B)
                                      : Color(0xffD6C9AE),
                                  shape: StadiumBorder()),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0, left: 20.0),
                      child: Text('Price',
                          style: TextStyle(
                              fontSize: 16, color: theme_color.black)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // use
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.only(top: 0.0, left: 20.0),
                              child: Row(children: [
                                Text('Rs.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: theme_color.button_color)),
                                Text(varient_price,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: theme_color.button_color)),
                                Text(' Rs.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: theme_color.light_grey)),
                                Text(varient_mrp,
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 20,
                                        color: theme_color.light_grey)),
                                /* Container(
                                width: 100,
                                child:  CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 18,
                                  child:
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                     // model.updateProduct(model.cart[index],
                                    //      model.cart[index].qty + 1);
                                    },
                                  ),
                                ),
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),

                              Container(
                                width: 100,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 18,
                                  child:  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                    //  model.updateProduct(model.cart[index],
                                    //      model.cart[index].qty - 1);
                                     },
                                  ),
                                ),
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),*/
                              ])),
                          Row(
                            children: [
                              Container(
                                width: 50,
                                child: CircleAvatar(
                                  backgroundColor: qty_color_minus,
                                  radius: 20,
                                  child: IconButton(
                                    icon: Icon(Icons.remove,
                                        color: qty_icon_color_minus),
                                    onPressed: () {
                                      _removeQuantity(1);
                                      qty_color_minus = theme_color.dark_green;
                                      qty_icon_color_minus = theme_color.white;
                                      qty_color_plus = Colors.transparent;
                                      qty_icon_color_plus =
                                          theme_color.dark_green;
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
                                  padding: const EdgeInsets.only(
                                      left: 1.0, right: 1.0),
                                  child: Center(
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      decoration: new InputDecoration(
                                        hintText: "1",
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: _quantityController,
                                    ),
                                  )),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 50,
                                  margin: const EdgeInsets.only(right: 20.0),
                                  child: CircleAvatar(
                                    backgroundColor: qty_color_plus,
                                    radius: 20,
                                    child: IconButton(
                                      icon: Icon(Icons.add,
                                          color: qty_icon_color_plus),
                                      onPressed: () {
                                        _addQuantity(1);
                                        qty_color_plus = theme_color.dark_green;
                                        qty_icon_color_plus = theme_color.white;
                                        qty_color_minus = Colors.transparent;
                                        qty_icon_color_minus =
                                            theme_color.dark_green;
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
                              ),
                            ],
                          ),
                        ]),
                  ),
                  /*Container(
                  height: 20,
                  margin: const EdgeInsets.only(
                      left:0,
                      top: 15,
                      right: 0,
                      bottom: 0),
                  child:
                  Dash(length: 350, dashColor:theme_color.light_grey),
                ),*/
                ],
              ),
            ),
            bottomNavigationBar: cart_button()),
      ],
    );
  }

  Widget cart_button() {
    if (out_of_stock == true) {
      return Padding(
        padding: const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 20),
        child: GestureDetector(
          onTap: () {
            //add_to_cart(selected_varient_id,widget.product_id);
          },
          child: Container(
            alignment: Alignment.center,
            height: 60,
            margin:
                const EdgeInsets.only(left: 25, top: 20, right: 20, bottom: 10),
            padding:
                const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme_color.red, theme_color.red]),
              border: Border.all(
                  color: theme_color.texbox_background, // set border color
                  width: 0.5), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(30.0)), // set rounded corner radius
              // make rounded corner of border
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 80, top: 0, right: 10, bottom: 0),
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/cart-icon-white.png',
                    height: 20,
                    width: 20,
                    // fit: BoxFit.fill,
                  ),
                ),
                Text(
                  ' OUT OF STOCK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 20),
        child: GestureDetector(
          onTap: () {
            add_to_cart(selected_varient_id, widget.product_id);
          },
          child: Container(
            alignment: Alignment.center,
            height: 60,
            margin:
                const EdgeInsets.only(left: 25, top: 20, right: 20, bottom: 10),
            padding:
                const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme_color.button_color, theme_color.button_color]),
              border: Border.all(
                  color: theme_color.texbox_background, // set border color
                  width: 0.5), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(30.0)), // set rounded corner radius
              // make rounded corner of border
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 80, top: 0, right: 10, bottom: 0),
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/cart-icon-white.png',
                    height: 20,
                    width: 20,
                    // fit: BoxFit.fill,
                  ),
                ),
                Text(
                  ' ADD TO CART',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  get_product_detail(String product_id) async {
    showLoaderDialog(context);
    final url = Urllink.get_product_detail;
    //String product_id='2';
    http.Response response = await http.post(Uri.parse(url), body: {
      "product_id": product_id,
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        productlist = datauser['data'] as List;
        product_string = productlist
            .map<product_detail_list>(
                (json) => product_detail_list.fromJson(json))
            .toList();
        varient_mrp = product_string[0].varient_mrp;
        varient_price = product_string[0].varient_price;
        selected_varient_id = product_string[0].product_varient_id;
        product_name = product_string[0].product_name;
        product_desc = product_string[0].product_desc;
        product_status = product_string[0].product_status;
        if (product_status == 'Out of stock') {
          out_of_stock = true;
        } else {
          out_of_stock = false;
        }
      });
    }
  }

  get_varient_data(String varient_id) async {
    showLoaderDialog(context);
    final url = Urllink.get_varient_data;
    http.Response response = await http.post(Uri.parse(url), body: {
      "varient_id": varient_id,
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        selected_varient_id = varient_id;
        varient_mrp = datauser['data']['varient_mrp'];
        varient_price = datauser['data']['varient_price'];
        varient_status = datauser['data']['varient_status'];
        if (varient_status == 'Out of stock') {
          out_of_stock = true;
        } else {
          out_of_stock = false;
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  add_to_cart(String varient_id, String product_id) async {
    showLoaderDialog(context);
    final url = Urllink.add_cart;
    String user_id = await prefs.ismember_id();
    String qty = _quantityController.text;
    http.Response response = await http.post(Uri.parse(url), body: {
      "varient_id": varient_id,
      "product_id": product_id,
      "user_id": user_id,
      "qty": qty
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);

      setState(() {
        _showDialog_product(context);
        /*Fluttertoast.showToast(
            msg: "Product Added To Cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);*/
      });
    } else {
      Navigator.pop(context);
    }
    get_cart();
  }

  void _showDialog_product(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          // title: new Text("Alert!!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.only(left: 0, top: 1, right: 0, bottom: 0),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/product-list-success.png"), // <-- BACKGROUND IMAGE
                  ),
                ),
              ),
              Container(
                  child: Text(
                'Item Successfully added to shopping list',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w800,
                ),
              )),
              InkWell(
                onTap: () {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  AppDrawer(
                          child: Home(),
                        ),
                      ));*/

                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  margin: const EdgeInsets.only(
                      left: 25, top: 20, right: 20, bottom: 10),
                  padding: const EdgeInsets.only(
                      left: 5, top: 10, right: 5, bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme_color.button_color,
                          theme_color.button_color
                        ]),
                    border: Border.all(
                        color:
                            theme_color.texbox_background, // set border color
                        width: 0.5), // set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(30.0)), // set rounded corner radius
                    // make rounded corner of border
                  ),
                  child: Text(
                    'CONTINUE SHOPPING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  get_banner() async {
    // showLoaderDialog(context);
    final url = Urllink.get_banner;
    http.Response response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        banner_list = datauser['data'] as List;
        banner_string =
            banner_list.map<Banners>((json) => Banners.fromJson(json)).toList();
      });
      return banner_string;
    }
  }

  void _addQuantity(int index) {
    setState(() {
      int s = int.parse(_quantityController.text);
      s++;
      _quantityController.text = '$s';
    });
  }

  void _removeQuantity(int index) {
    setState(() {
      if (int.parse(_quantityController.text) > 0) {
        int s = int.parse(_quantityController.text);
        s--;
        _quantityController.text = '$s';
      } else {
        quantity = 0;
      }
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Promo Code'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  promo_code = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Promocode"),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget show_banner(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: get_banner(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: [
                  Container(
                    child: CarouselSlider.builder(
                      itemCount: snapshot.data.length,
                      options: CarouselOptions(
                        enlargeCenterPage: false,
                        height: 235,
                        reverse: false,
                        viewportFraction: 1,
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                snapshot.data[i].banner_img,
                                width: 500,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            var url = snapshot.data[i].banner_img;
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
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
