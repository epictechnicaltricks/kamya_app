// ignore_for_file: camel_case_types

import 'dart:math';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/Model/address.dart';
import 'package:kamya_app/Model/order.dart';
import 'package:kamya_app/my_address.dart';
import 'package:kamya_app/order_summary.dart';
import 'package:kamya_app/prefs_file.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'AppDrawer.dart';
import 'Model/Slot_model.dart';
import 'Model/cart.dart';
import 'Model/notification.dart';
import 'Urllink.dart';
import 'add_address.dart';
import 'cart.dart';
import 'home.dart';
import 'package:intl/intl.dart';

class checkout extends StatefulWidget {
  var orderdata;
  String total;
  checkout(this.orderdata, this.total);
  @override
  _checkoutState createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  List _selectedIndexs = [];
  Prefs prefs = new Prefs();
  String wallet_bal = '';

  List notification_list = [];
  List<Notification_list> notification_string = [];

  List cartlist = [];
  List<cart_list> cart_string = [];

  List addresslist = [];
  List<address_list> address_string = [];

  TextEditingController choose_date = new TextEditingController();
  TextEditingController choose_time = new TextEditingController();
  String radioButtonItem = 'PICKUP';
  String selected_address = '0';
  String radioButtonItem_payment = '';
  String transaction_id = '';
  String payment_type = 'COD';
  String payment_status = 'Pending';
  late String status;
  late int selected = 0;
  int id = 1;
  bool pickup_box = true;
  bool choose_time_div = false;
  late String _value;
  late DateTime _selectedDate;
  int payment_id = 1;
  int address_group = 1;
  TimeOfDay selectedTime = TimeOfDay.now();
  List _All_Slot_List = [];
  List<All_Slot> _All_Slot_String = [];
  String selected_slot = '';
  String selected_time = '';
  late List<place_order_model> order_data;

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

  /*_selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2040),
       );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      choose_date
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: choose_date.text.length,
            affinity: TextAffinity.upstream));
    }
  }*/
  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        choose_date
          ..text = DateFormat.yMMMd().format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: choose_date.text.length,
              affinity: TextAffinity.upstream));
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
        choose_time.text = "${selectedTime.hour}:${selectedTime.minute}";
        print(choose_time.text);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      get_my_address();
      get_cart();
      get_wallet();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      String tomorrow_formatter = DateFormat('dd-MM-yyyy').format(tomorrow);

      DateTime now = DateTime.now();
      print('now${now.hour}');
      setState(() {
        if (now.hour > 15) {
          _selectedDate = tomorrow;
          choose_date..text = DateFormat.yMMMd().format(tomorrow);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // <-- STACK AS THE SCAFFOLD PARENT
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
          backgroundColor: Colors.transparent,
          // <-- SCAFFOLD WITH TRANSPARENT BG
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            // <-- SCAFFOLD WITH TRANSPARENT BG
            elevation: 0,
            // automaticallyImplyLeading: false,
            title: Text(
              "Payment",
              style: new TextStyle(
                color: theme_color.white,
              ),
            ),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
                margin: const EdgeInsets.only(
                    left: 5, top: 30, right: 5, bottom: 0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: 25,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 0, right: 15, bottom: 0),
                        padding: const EdgeInsets.only(
                            left: 15, top: 0, right: 5, bottom: 0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Order Type',
                          style: new TextStyle(
                            fontFamily: "Roboto",
                            color: theme_color.button_color,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 0, top: 0, right: 0, bottom: 5),
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      height: 45,
                      child: Row(
                        children: [
                          Radio(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => theme_color.light_green),
                            value: 2,
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                choose_time_div = false;
                                radioButtonItem = 'Delivery';
                                pickup_box = true;
                                id = 2;
                              });
                            },
                          ),
                          Text(
                            'Delivery',
                            style: new TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      height: 55,
                      child: Row(
                        children: [
                          Radio(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => theme_color.light_green),
                            value: 1,
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                radioButtonItem = 'Pick Up';
                                pickup_box = true;
                                id = 1;
                              });
                            },
                          ),
                          Text(
                            'PickUp',
                            style: new TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: pickup_box,
                      child: Container(
                        height: 45,
                        margin: const EdgeInsets.only(
                            left: 30, top: 0, right: 10, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: new TextField(
                                  onTap: () {
                                    // Below line stops keyboard from appearing
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    _selectDate(context);
                                    // Show Date Picker Here
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: choose_date,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: 'Choose Date',
                                    hintStyle: TextStyle(fontSize: 15),
                                    // you need this
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        _selectDate(context);
                                      },
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 23.0,
                            ),
                            new Flexible(
                              child: new TextField(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    //_selectTime(context);
                                    // Show Date Picker Here
                                    get_time_slot(context, '');
                                    setState(() {
                                      choose_time_div = true;
                                    });
                                  },
                                  controller: choose_time,
                                  decoration: InputDecoration(
                                    hintText: 'Choose Time',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        //_selectTime(context);
                                        // Show Date Picker Here
                                        get_time_slot(context, '');
                                      },
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: choose_time_div,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 0, right: 5, bottom: 0),
                        child: Container(
                          height: 200,
                          child: GridView.builder(
                            itemCount: _All_Slot_String.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 6),
                            ),
                            itemBuilder: (context, index) {
                              return Center(
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: selected == index
                                          ? theme_color.light_green
                                          : Colors.transparent,
                                      border: Border.all(
                                          color: theme_color.dark_green)),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = index;
                                      });
                                      choose_time.text =
                                          "${_All_Slot_String[index].slot_time}";
                                    },
                                    child: Text(
                                      _All_Slot_String[index].slot_time,
                                      style: new TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: selected == index
                                              ? theme_color.white
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 10, right: 15, bottom: 0),
                        padding: const EdgeInsets.only(
                            left: 15, top: 0, right: 5, bottom: 0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Payment Method',
                          style: new TextStyle(
                            fontFamily: "Roboto",
                            color: theme_color.button_color,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      height: 35,
                      child: Row(
                        children: [
                          Radio(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => theme_color.light_green),
                            value: 1,
                            groupValue: payment_id,
                            onChanged: (val) {
                              setState(() {
                                radioButtonItem_payment = 'Cash On Delivery';
                                payment_id = 1;
                              });
                            },
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              children: [
                                WidgetSpan(
                                  child: Image.asset("assets/cash.png",
                                      width: 22, color: theme_color.black),
                                ),
                                TextSpan(
                                  text: ' Cash On Delivery',
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      height: 35,
                      child: Row(
                        children: [
                          Radio(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => theme_color.light_green),
                            value: 2,
                            groupValue: payment_id,
                            onChanged: (val) {
                              setState(() {
                                radioButtonItem_payment = 'Card';
                                payment_id = 2;
                              });
                            },
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              children: [
                                WidgetSpan(
                                  child: Image.asset("assets/card.png",
                                      width: 22, color: theme_color.black),
                                ),
                                TextSpan(
                                  text: ' Debit/Credit Card',
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      height: 35,
                      child: Row(
                        children: [
                          Radio(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => theme_color.light_green),
                            value: 3,
                            groupValue: payment_id,
                            onChanged: (val) {
                              setState(() {
                                radioButtonItem_payment = 'Wallet';
                                payment_id = 3;
                                payment_type = 'Wallet';
                              });
                            },
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              children: [
                                WidgetSpan(
                                  child: Image.asset("assets/wallet.png",
                                      width: 22, color: theme_color.black),
                                ),
                                TextSpan(
                                  text: ' Wallet(₹ ${wallet_bal})',
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, top: 0, right: 5, bottom: 0),
                      height: 35,
                      child: Row(
                        children: [
                          Radio(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => theme_color.light_green),
                            value: 4,
                            groupValue: payment_id,
                            onChanged: (val) {
                              setState(() {
                                radioButtonItem_payment = 'Net Banking';
                                payment_id = 4;
                              });
                            },
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              children: [
                                WidgetSpan(
                                  child: Image.asset("assets/bank.png",
                                      width: 22, color: theme_color.black),
                                ),
                                TextSpan(
                                  text: ' Net Banking',
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 45,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ),
                        ),
                        margin: const EdgeInsets.only(
                            left: 15, top: 10, right: 15, bottom: 0),
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, right: 5, bottom: 0),
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(
                              'Select Address',
                              style: new TextStyle(
                                fontFamily: "Roboto",
                                color: theme_color.button_color,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => add_address(),
                                    ));
                              },
                              child: Text(
                                ' (Add New Address)',
                                style: new TextStyle(
                                  fontFamily: "Roboto",
                                  color: theme_color.dark_green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      // <- added
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 0, right: 5, bottom: 0),
                        child: Container(
                          height: 200,
                          child: address_string.length == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 0,
                                            top: 20,
                                            right: 0,
                                            bottom: 0),
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/shopping-list-active.png"),
                                            // <-- BACKGROUND IMAGE
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            top: 20,
                                            right: 10,
                                            bottom: 10),
                                        child: Text(
                                          'No Address Found!',
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
                                            left: 25,
                                            top: 5,
                                            right: 20,
                                            bottom: 10),
                                        child: Text(
                                          'No Addresses have been added yet. Please add an address.',
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
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: address_string.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            top: 0,
                                            right: 0,
                                            bottom: 5),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.0, color: Colors.grey),
                                          ),
                                        ),
                                        height: 140,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Radio(
                                              fillColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      theme_color.light_green),
                                              value: int.parse(
                                                  address_string[index]
                                                      .addr_id),
                                              groupValue: address_group,
                                              onChanged: (val) {
                                                setState(() {
                                                  selected_address =
                                                      address_string[index]
                                                          .addr_id;
                                                  address_group = int.parse(
                                                      selected_address);
                                                  print(
                                                      'selected_address${address_group}');
                                                });
                                              },
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              top: 10,
                                                              right: 0,
                                                              bottom: 5),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 10,
                                                              right: 4,
                                                              bottom: 0),
                                                      child: Text(
                                                        address_string[index]
                                                            .addr_type,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color:
                                                              theme_color.black,
                                                          fontSize: 20,
                                                          fontFamily:
                                                              "Quicksand",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              top: 0,
                                                              right: 0,
                                                              bottom: 5),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 0,
                                                              right: 4,
                                                              bottom: 0),
                                                      child: Text(
                                                        address_string[index]
                                                            .addr_address_1,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color:
                                                              theme_color.black,
                                                          fontSize: 17,
                                                          fontFamily:
                                                              "Quicksand",
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              top: 5,
                                                              right: 0,
                                                              bottom: 5),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 0,
                                                              right: 4,
                                                              bottom: 0),
                                                      child: Text(
                                                        address_string[index]
                                                                .addr_address_2 +
                                                            ',' +
                                                            address_string[
                                                                    index]
                                                                .addr_city,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              top: 5,
                                                              right: 0,
                                                              bottom: 5),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 0,
                                                              right: 4,
                                                              bottom: 0),
                                                      child: Text(
                                                        //'Mobile:'+address_string[index]?.addr_phone,
                                                        'Mobile:',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color:
                                                              theme_color.black,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Quicksand",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              top: 5,
                                                              right: 0,
                                                              bottom: 5),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              top: 0,
                                                              right: 4,
                                                              bottom: 0),
                                                      child: Text(
                                                        //'Mobile:'+address_string[index]?.addr_phone,
                                                        address_string[index]
                                                            .addr_phone,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color:
                                                              theme_color.black,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Quicksand",
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          bottomNavigationBar: GestureDetector(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (choose_date.text == '') {
                      Fluttertoast.showToast(
                          msg: "Please select date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: theme_color.red,
                          textColor: theme_color.black,
                          fontSize: 15.0);
                    } else if (choose_time.text == '') {
                      Fluttertoast.showToast(
                          msg: "Please select time",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: theme_color.red,
                          textColor: theme_color.black,
                          fontSize: 15.0);
                    } else if (selected_address == '0' &&
                        radioButtonItem == 'Delivery') {
                      Fluttertoast.showToast(
                          msg: "Please select address",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: theme_color.red,
                          textColor: theme_color.black,
                          fontSize: 15.0);
                    } else if (payment_id == 1) {
                      place_order();
                    } else if (payment_id == 3) {
                      check_wallet();
                    } else {
                      openCheckout();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width - 50,
                    margin: const EdgeInsets.only(
                        left: 25, top: 10, right: 25, bottom: 10),
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
                          color: theme_color.texbox_background,
                          // set border color
                          width: 0.5), // set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0)), // set rounded corner radius
                      // make rounded corner of border
                    ),
                    child: Text(
                      'Place Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500,
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

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        delete_address(id);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text("You won't be able to revert it."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
      "order_amount": widget.total,
    });
    print(user_id);
    if (response.statusCode == 200) {
      //  Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      String token = datauser['cftoken'];
      String user_phone = await prefs.isphone_num();
      print('mobile_number${user_phone}');
      String user_name = await prefs.isuser_name();

      Map<String, dynamic> inputParams = {
        "orderId": orderId,
        "orderAmount": widget.total,
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
          payment_type = 'ONLINE';
        });

        if (ans == 'SUCCESS') {
          place_order();
        } else {
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

  get_cart() async {
    final url = Urllink.get_user_cart;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
    });
    print(user_id);
    if (response.statusCode == 200) {
      //  Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        cartlist = datauser['data'] as List;
        cart_string = cartlist
            .map<cart_list>((json) => cart_list.fromJson(json))
            .toList();
      });
    }
  }

  get_card_data() {
    print("widget.orderdata:::${widget.orderdata}");
    List jsonList =
        order_data.map((order_data) => widget.orderdata.toJson()).toList();

    String json = jsonEncode(
            order_data.map((orderdata) => widget.orderdata.toJson()).toList())
        .toString();
    print("order_data:::${json}");
  }

  get_wallet() async {
    final url = Urllink.get_wallet;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> datauser = json.decode(response.body);
      print('datauser${datauser}');
      setState(() {
        wallet_bal = datauser['wallet'];
      });
    }
  }

  check_wallet() {
    if (payment_type == 'Wallet') {
      double ordertotal = double.parse(widget.total);
      double wallettotal = double.parse(wallet_bal);
      if (ordertotal > wallettotal) {
        Fluttertoast.showToast(
            msg: "Insufficient balance in wallet",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);
        return false;
      } else {
        place_order();
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

  place_order() async {
    showLoaderDialog(context);

    final url = Urllink.place_order;
    String user_id = await prefs.ismember_id();
    print("user_id${user_id}");
    String discount = await prefs.get_discount();
    String promocode = await prefs.get_coupon();
    print('discount${discount}');

    http.Response response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
      "promocode": '${promocode}',
      "discount": '${discount}',
      "address_id": selected_address,
      "transaction_id": transaction_id,
      "payment_status": payment_status,
      "payment_method": payment_type,
      "choosen_date": choose_date.text,
      'choosen_time': choose_time.text,
      'order_type': radioButtonItem,
      'order_total': '${widget.total}',
    });
    print(response.body);
    Navigator.pop(context);

    if (response.statusCode == 200) {
      Map<String, dynamic> datauser = json.decode(response.body);
      String order_id = datauser['order_id'];

      setState(() {
        if (datauser["success"] == '0') {
          Fluttertoast.showToast(
              msg: "Order Placed Successfully.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => order_summary(order_id),
              ));
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.red,
              textColor: theme_color.black,
              fontSize: 15.0);
        }
      });
    }
  }

  delete_address(addr_id) async {
    print(addr_id);
    var url = Urllink.delete_address;
    final response = await http.post(Uri.parse(url), body: {
      "addr_id": addr_id,
    });

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          Fluttertoast.showToast(
              msg: "Address deleted successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);
        });
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: "Something went wrong.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: theme_color.black,
              fontSize: 15.0);
        });
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => my_address(),
          ));
    }
  }

  get_my_address() async {
    //showLoaderDialog(context);
    final url = Urllink.get_my_address;
    String user_id = await prefs.ismember_id();
    http.Response response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
    });
    print(user_id);
    if (response.statusCode == 200) {
      //Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        addresslist = datauser['data'] as List;
        address_string = addresslist
            .map<address_list>((json) => address_list.fromJson(json))
            .toList();
        if (address_string.length > 0) {
          // show_button=true;
        }
      });
    }
  }

  Future<void> get_time_slot(BuildContext ctx, selectedDate) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    //final DateFormat formatter = choose_date.text as DateFormat;
    final String formatted = formatter.format(_selectedDate);
    var url = Urllink.get_slot_time;
    final response = await http.post(Uri.parse(url), body: {"day": formatted});

    Map<String, dynamic> datauser = json.decode(response.body);

    status = datauser["success"];
    print("datauser_slot_time ::  ${datauser['data']}");
    _All_Slot_List = [];
    _All_Slot_String = [];
    setState(() {
      _All_Slot_List = datauser['data'] as List;
      _All_Slot_String =
          _All_Slot_List.map<All_Slot>((json) => All_Slot.fromJson(json))
              .toList();
    });
    if (response.statusCode == 200) {
      /*if (status == "0") {
        showModalBottomSheet(
            context: ctx,
            builder: (BuildContext ctx) {
              return Container(
                height: 200.0,
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        backgroundColor: Colors.white,
                        itemExtent: 30,
                        scrollController: FixedExtentScrollController(initialItem: 0),
                        children: [
                          for(var item in _All_Slot_String ) Text(item.slot_time)
                        ],
                        onSelectedItemChanged: (value) {
                          selected_time='${value.toString()}' ;
                          selected_time = _All_Slot_String.elementAt(value).slot_time;
                          selected_slot = selected_time;

                          print("selected_slot  : ${selected_slot}");
                          choose_time.text=selected_slot;
                        },
                      ),
                    ),
                    CupertinoButton(
                      child: Text("Ok"),
                      onPressed: () {
                        setState(() {

                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            });

      }*/
    }
  }
}
