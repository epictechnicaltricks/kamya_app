import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/Model/order.dart';
import 'package:kamya_app/Model/promocode.dart';
import 'package:kamya_app/add_address.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:kamya_app/product_detail.dart';
import 'package:kamya_app/promocode_screen.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'AppDrawer.dart';
import 'Dash.dart';
import 'Model/product.dart';
import 'Urllink.dart';
import 'cart.dart';
import 'Model/cart.dart';
import 'checkout.dart';
import 'home.dart';
import 'notifications.dart';

class cart extends StatefulWidget {
  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {
  List cart_item = [];
  List<place_order_model> orderdata = [];

  List cartlist = [];
  List<cart_list> cart_string = [];
  String radioButtonItem = 'Home';
  late String status;
  String empty_cart = '0';
  int id = 1;
  int sum = 0;
  int sum_qty = 0;
  int sum_product = 0;
  String Sub_total = '';
  String total = '';
  String final_total = '';
  String tax = '';
  late String promo_code;
  late String total_promo;
  String discount = '0';
  String discount_applied = '0';
  List promocodelist = [];
  List<promocode_list> promocode_string = [];

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController search_product = new TextEditingController();
  Prefs prefs = new Prefs();
  List<TextEditingController> _quantityController = [];
  int quantity = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_cart();
      this.get_promocode();

      // total_cart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // <-- STACK AS THE SCAFFOLD PARENT
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
          backgroundColor:
              Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
          appBar: AppBar(
            centerTitle: false,
            backgroundColor:
                Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
            elevation: 0,
            // automaticallyImplyLeading: false,
            title: Text("Checkout"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home())),
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
          body: empty_cart == '1'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 0, top: 150, right: 0, bottom: 0),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/cart-big.png"), // <-- BACKGROUND IMAGE
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                            left: 10, top: 20, right: 10, bottom: 10),
                        child: Text(
                          'Your cart is empty!',
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
                      child: Container(
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
                              builder: (context) => Home(),
                            ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        margin: const EdgeInsets.only(
                            left: 25, top: 130, right: 20, bottom: 10),
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
                              color: theme_color
                                  .texbox_background, // set border color
                              width: 0.5), // set border width
                          borderRadius: BorderRadius.all(Radius.circular(
                              30.0)), // set rounded corner radius
                          // make rounded corner of border
                        ),
                        child: Text(
                          'START SHOPPING',
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
                )
              : SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: 430,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 17, left: 10),
                        child: ListView.builder(
                          itemCount: cart_string.length,
                          itemBuilder: (context, index) {
                            orderdata.add(
                              place_order_model(
                                product_id: cart_string[index].product_id,
                                varient_id: cart_string[index].varient_id,
                                payment_status: 'SUCCESS',
                                qty: cart_string[index].qty,
                                address_id: '1',
                                payment_method: 'COD',
                                transaction_id: '123',
                                order_date: '',
                                choosen_date: '',
                                choosen_time: '',
                              ),
                            );

                            return Dismissible(
                              key: Key('item ${cart_string[index]}'),
                              background: Container(
                                color: Color(0xffEB7C77),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            top: 25,
                                            right: 30,
                                            bottom: 0),
                                        child: Column(
                                          children: <Widget>[
                                            Center(
                                                child: Icon(Icons.delete,
                                                    color: Colors.white)),
                                            Center(
                                                child: Text('Cancel',
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete Confirmation"),
                                      content: const Text(
                                          "Are you sure you want to delete this item?"),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              delete_cart(
                                                  cart_string[index].cart_id);
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text("Delete")),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
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
                                  cart_string.removeAt(index);
                                });
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Container(
                                  height: 115,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: 80,
                                                height: 80,
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    top: 10,
                                                    right: 10,
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    theme_color.white,
                                                    theme_color.white,
                                                  ]),
                                                  border: Border.all(
                                                      color: theme_color
                                                          .button_color, // set border color
                                                      width:
                                                          0.5), // set border width
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          23.0)), // set rounded corner radius
                                                  // make rounded corner of border
                                                ),
                                                child: Image.network(
                                                  cart_string[index]
                                                      .product_img,
                                                  height: 10,
                                                  width: 10,
                                                  // fit: BoxFit.fill,
                                                ),
                                              ),
                                              Container(
                                                width: 270,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      product_detail(
                                                                          cart_string[index]
                                                                              .product_id)),
                                                            );
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    top: 10,
                                                                    right: 0,
                                                                    bottom: 5),
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    top: 10,
                                                                    right: 4,
                                                                    bottom: 0),
                                                            child: Text(
                                                              cart_string[index]
                                                                  .product_name,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color:
                                                                    theme_color
                                                                        .black,
                                                                fontSize: 16,
                                                                //fontFamily: "Quicksand",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  top: 5,
                                                                  right: 0,
                                                                  bottom: 0),
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 0,
                                                                  right: 4,
                                                                  bottom: 0),
                                                          child: Text(
                                                            cart_string[index]
                                                                .varient_name,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: 70,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  top: 5,
                                                                  right: 0,
                                                                  bottom: 5),
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 3,
                                                                  top: 0,
                                                                  right: 1,
                                                                  bottom: 0),
                                                          child: Text(
                                                            'Rs.' +
                                                                cart_string[
                                                                        index]
                                                                    .varient_price +
                                                                '.00',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              color: theme_color
                                                                  .black,
                                                              fontSize: 12,
                                                              //fontFamily: "Quicksand",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 65,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  top: 5,
                                                                  right: 0,
                                                                  bottom: 5),
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 3,
                                                                  top: 0,
                                                                  right: 3,
                                                                  bottom: 0),
                                                          child: Text(
                                                            'Rs.' +
                                                                cart_string[
                                                                        index]
                                                                    .varient_mrp +
                                                                '.00',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              color: theme_color
                                                                  .texbox_background,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontSize: 12,
                                                              //fontFamily: "Quicksand",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            radius: 20,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                Icons.remove,
                                                                color: _quantityController[index]
                                                                            .text !=
                                                                        "1"
                                                                    ? theme_color
                                                                        .dark_green
                                                                    : theme_color
                                                                        .light_grey,
                                                              ),
                                                              onPressed: () {
                                                                _removeQuantity(
                                                                    index);
                                                              },
                                                            ),
                                                          ),
                                                          decoration:
                                                              new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border:
                                                                new Border.all(
                                                              color: _quantityController[
                                                                              index]
                                                                          .text !=
                                                                      "1"
                                                                  ? theme_color
                                                                      .dark_green
                                                                  : theme_color
                                                                      .light_grey,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                            width: 25.0,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 1.0,
                                                                    right: 1.0),
                                                            child: Center(
                                                              child: TextField(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                decoration:
                                                                    new InputDecoration(
                                                                  hintText: "1",
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    _quantityController[
                                                                        index],
                                                              ),
                                                            )),
                                                        Container(
                                                          width: 50,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            radius: 20,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                  Icons.add,
                                                                  color: theme_color
                                                                      .dark_green),
                                                              onPressed: () {
                                                                _addQuantity(
                                                                    index);
                                                                add_qty(cart_string[
                                                                        index]
                                                                    .cart_id);
                                                              },
                                                            ),
                                                          ),
                                                          decoration:
                                                              new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border:
                                                                new Border.all(
                                                              color: theme_color
                                                                  .dark_green,
                                                              width: 1.0,
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
                                          Row(
                                            children: [
                                              Dash(
                                                  length: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  dashColor:
                                                      theme_color.light_grey),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(
                            left: 30, top: 10, right: 30, bottom: 0),
                        decoration: BoxDecoration(
                          color: Color(0xffEBDEC3),
                          borderRadius: BorderRadius.all(Radius.circular(
                              25.0)), // set rounded corner radius
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                //  _displayTextInputDialog(context);
                              },
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                    left: 10, top: 16, right: 10, bottom: 10),
                                child: Text(
                                  'Apply Promotion Code',
                                  style: TextStyle(
                                    color: theme_color.button_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            promocode_screen()));
                              },
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                    left: 10, top: 16, right: 10, bottom: 10),
                                child: Text(
                                  '${promocode_string.length} Promos',
                                  style: TextStyle(
                                    color: Color(0xffFC7474),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 0),
                        child: Dash(
                            length: 350, dashColor: theme_color.light_grey),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Subtotal',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffBBAD92),
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                Sub_total,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffBBAD92),
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                      /* Container(
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                  Align(
                  alignment: Alignment.centerLeft,
                    child:Text('TAX',style: TextStyle(fontSize: 16,color: Color(0xffBBAD92),fontWeight: FontWeight.w800),),),
                      Text(tax,style: TextStyle(fontSize: 16,color: Color(0xffBBAD92),fontWeight: FontWeight.w800),),
                      //
                    ],
                  ),),*/
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Discount',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffBBAD92),
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            Text(
                              '₹ ${discount}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xffBBAD92),
                                  fontWeight: FontWeight.w800),
                            ),
                            //
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: theme_color.button_color,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              total,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: theme_color.button_color,
                                  fontWeight: FontWeight.w500),
                            ),
                            //
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 5, top: 10, right: 5, bottom: 20),
                        child: InkWell(
                          onTap: () {
                            //prefs.set_discount('0');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        checkout(orderdata, final_total)));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
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
                                  color: theme_color
                                      .texbox_background, // set border color
                                  width: 0.5), // set border width
                              borderRadius: BorderRadius.all(Radius.circular(
                                  30.0)), // set rounded corner radius
                              // make rounded corner of border
                            ),
                            child: Text(
                              'CONFIRM',
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
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  set_qty() {
    for (var i = 0; i < cart_string.length; i++) {
      _quantityController.add(new TextEditingController());
      _quantityController[i].text = cart_string[i].qty;
    }
  }

  update_total() {
    int sum_total = 0;
    for (var i = 0; i < cart_string.length; i++) {
      sum_total += int.parse(_quantityController[i].text) *
          int.parse(cart_string[i].varient_price);
    }
    Sub_total = '₹' + sum_total.toString();
    total = '₹' + sum_total.toString();
    final_total = sum_total.toString();
  }

  total_cart() async {
    sum_product = 0;
    discount = await prefs.get_discount();
    int disc = int.parse(discount);
    for (var i = 0; i < cart_string.length; i++) {
      sum += int.parse(cart_string[i].varient_price);
      print('qty${cart_string[i].qty}');
      sum_product += int.parse(cart_string[i].qty) *
          int.parse(cart_string[i].varient_price);
    }
    int f_total = sum_product - disc;
    Sub_total = '₹' + sum_product.toString();
    total = '₹' + f_total.toString();
    final_total = f_total.toString();

    tax = '₹ 0';
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
              decoration: InputDecoration(hintText: "Promo code"),
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

  add_qty(String cart_id) async {
    showLoaderDialog(context);
    print('cart_id${cart_id}');

    final url = Urllink.add_cart_qty;
    http.Response response = await http.post(Uri.parse(url), body: {
      "cart_id": cart_id,
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      print('add_cart${datauser['data']}');
      setState(() {
        Fluttertoast.showToast(
            msg: "Product Qty Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);
      });
    } else {
      Navigator.pop(context);
    }
    get_cart();
  }

  remove_qty(String cart_id) async {
    showLoaderDialog(context);
    final url = Urllink.remove_cart_qty;
    http.Response response = await http.post(Uri.parse(url), body: {
      "cart_id": cart_id,
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      print(datauser['data']);
      setState(() {
        Fluttertoast.showToast(
            msg: "Product Removed From Cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);
      });
    } else {
      Navigator.pop(context);
    }
    get_cart();
  }

  delete_cart(String cart_id) async {
    showLoaderDialog(context);
    final url = Urllink.delete_cart;
    http.Response response = await http.post(Uri.parse(url), body: {
      "cart_id": cart_id,
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      print(datauser['data']);
      setState(() {
        Fluttertoast.showToast(
            msg: "Product Removed From Cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);
      });
    } else {
      Navigator.pop(context);
    }
    get_cart();
  }

  void _addQuantity(int index) {
    setState(() {
      int s = int.parse(_quantityController[index].text);
      s++;
      _quantityController[index].text = '$s';
    });
    update_total();
  }

  void _removeQuantity(int index) {
    setState(() {
      if (int.parse(_quantityController[index].text) > 1) {
        int s = int.parse(_quantityController[index].text);
        s--;
        _quantityController[index].text = '$s';
        remove_qty(cart_string[index].cart_id);
      } else {
        quantity = 0;
      }
      update_total();
    });
  }

  get_promocode() async {
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
        promocode_string = promocodelist
            .map<promocode_list>((json) => promocode_list.fromJson(json))
            .toList();
      });
    }
  }

  get_cart() async {
    discount = await prefs.get_discount();
    showLoaderDialog(context);
    final url = Urllink.get_user_cart;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
    });
    print(user_id);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        cartlist = datauser['data'] as List;
        print(cartlist);
        cart_string = cartlist
            .map<cart_list>((json) => cart_list.fromJson(json))
            .toList();
      });
      total_cart();
      set_qty();
      if (cart_string.length == 0) {
        empty_cart = '1';
      }
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
