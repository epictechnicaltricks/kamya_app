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
import 'package:rating_dialog/rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AppDrawer.dart';
import 'Dash.dart';
import 'Model/product.dart';
import 'Urllink.dart';
import 'cart.dart';
import 'home.dart';
import 'notifications.dart';

class order_summary extends StatefulWidget {
  String order_id;
  order_summary(this.order_id);

  @override
  _order_summaryState createState() => _order_summaryState();
}
class _order_summaryState extends State<order_summary> {
  List productlist = [];
  List<product_list> product_string = [];
  List orderlist = [];
  List<order_list_model> order_string = [];

  String radioButtonItem = 'Home';
  late String status;
  int id = 1;
  int tappedIndex=0;
  TextEditingController search_product = new TextEditingController();
  Prefs prefs = new Prefs();
  String total='200.0';
  String Sub_total='180.0';
  String tax='0.0';
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      get_my_order();
      get_order_detail();

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
              image: AssetImage("assets/order_bg.jpg"), // <-- BACKGROUND IMAGE
              fit: BoxFit.fitHeight,
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
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),



          ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child:                    Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child:Container(
                    margin: const EdgeInsets.only(
                        left: 0, top: 30, right: 0, bottom: 0),
                    height:150,
                    width:150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/success-white-check.png"), // <-- BACKGROUND IMAGE
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Center(
                  child:Container(
                    height: 70,
                    margin: const EdgeInsets.only(
                        left: 20, top:50, right: 20, bottom: 0),
                    child: Text('Your order status is ${order_string[0].order_status}!',  textAlign: TextAlign.center,
                        style: TextStyle(color: theme_color.dark_green,fontSize: 26,fontWeight: FontWeight.w700)),
                  ),
                ),
                Container(
                  height: 20,
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),
                  child: Text('Order Details',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 15,fontWeight: FontWeight.w700)),
                ),
                Container(
                  height: 20,
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),
                  child: Text('Your Order ID #KAMYA${order_string[0].order_id}',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 12,fontWeight: FontWeight.w700)),
                ),

                Container(
                  height: 40,
                  margin: const EdgeInsets.only(
                      left: 20, top:5, right: 20, bottom: 0),
                  child: Text('An email receipt including the details about your order has been sent to your email address.',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 14)),
                ),
                Container(
                  height: 20,
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),
                  child: Text('This order will be shipped to:',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 15,fontWeight: FontWeight.w600)),
                ),

                Container(
                  height: 15,
                  margin: const EdgeInsets.only(
                      left: 20, top:5, right: 20, bottom: 0),
                  child: Text('${order_string[0].addr_address_1}',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 14)),
                ),
                Container(
                  height: 15,
                  margin: const EdgeInsets.only(
                      left: 20, top:5, right: 20, bottom: 0),
                  child: Text('${order_string[0].addr_address_2}',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 14)),
                ),
                Container(
                  height: 15,
                  margin: const EdgeInsets.only(
                      left: 20, top:5, right: 20, bottom: 0),
                  child: Text('${order_string[0].addr_near_by}',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 14)),
                ),
                Container(
                  height: 15,
                  margin: const EdgeInsets.only(
                      left: 20, top:5, right: 20, bottom: 0),
                  child: Text('${order_string[0].addr_city}-${order_string[0].addr_pincode}',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 14)),
                ),
                Container(
                  height: 17,
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),
                  child: Text('Payment Method:',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 15,fontWeight: FontWeight.w700)),
                ),
                Container(
                  height: 15,
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),
                  child: Text('${order_string[0].payment_method} (${order_string[0].order_type})',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 13)),
                ),
                Container(
                  height: 17,
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),
                  child: Text('Date & Time:',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 15,fontWeight: FontWeight.w700)),
                ),
                Container(
                  height: 15,
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),
                  child: Text('${order_string[0].choosen_date} ${order_string[0].choosen_time} ',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 13)),
                ),
                Container(
                  height: 20,
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),
                  child: Text('Order Summary:',  textAlign: TextAlign.left,
                      style: TextStyle(color: theme_color.black,fontSize: 15,fontWeight: FontWeight.w700)),
                ),
                Container(
                  height:200,
                  width:MediaQuery.of(context).size.width,

                  child:ListView.builder(
                    itemCount: product_string.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [

                          Card(
                            elevation: 0,
                            color: Color(0xffFFF9ED),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                                ),
                              ),
                              height:80,
                              width:MediaQuery.of(context).size.width,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: <Widget>[
                                  Container(
                                    width:55,
                                    height:55,
                                    padding: const EdgeInsets.only(left: 10, top:10, right: 10, bottom: 10),
                                    margin: const EdgeInsets.only(left: 10, top:10, right: 10, bottom: 10),
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
                                    child: Image.network(
                                      product_string[index].product_img,
                                      height: 10,
                                      width: 10,
                                      // fit: BoxFit.fill,
                                    ),
                                  ),


                                  Column(

                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[

                                          Container(
                                            width:300,
                                            child: Column(
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
                                                            left: 10, top:10, right: 4, bottom: 0),
                                                        child:Text(
                                                          product_string[index].product_name,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            color: theme_color.black,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                  children:<Widget>[
                                                    Container(
                                                      padding: const EdgeInsets.only(
                                                          left: 0, top: 5, right: 0, bottom: 5),
                                                      margin: const EdgeInsets.only(
                                                          left: 5, top: 0, right: 4, bottom: 0),

                                                      child:
                                                      Text(
                                                        product_string[index].varient_name+','+ product_string[index].varient_price,
                                                        style: TextStyle(color: Colors.black,fontSize: 12),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.only(
                                                          left: 0, top: 5, right: 0, bottom: 5),
                                                      margin: const EdgeInsets.only(
                                                          left: 5, top: 0, right: 4, bottom: 0),

                                                      child:
                                                      Text(
                                                        'Rs.'+product_string[index].varient_price+'.00',
                                                        style: TextStyle(color: theme_color.button_color,fontWeight: FontWeight.w700,),
                                                      ),
                                                    ),
                                                    /*Container(
                                                      padding: const EdgeInsets.only(
                                                          left: 0, top: 5, right: 0, bottom: 5),
                                                      margin: const EdgeInsets.only(
                                                          left: 5, top: 0, right: 4, bottom: 0),

                                                      child:
                                                      Text('12 January 2022,12:25 PM',
                                                        style: TextStyle(color:theme_color.text_color,fontSize: 10),

                                                      ),
                                                    ),*/


                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),


                                        ],
                                      ),

                                    ],
                                  )

                                ],
                              ),

                            ),
                          ),

                        ],
                      );


                    },

                  ),

                ),
                Container(
                margin: const EdgeInsets.only(
                left: 20, top:5, right: 20, bottom: 0),
                child:Dash(length: 350, dashColor:theme_color.light_grey),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20, top:10, right: 20, bottom: 0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child:Text('Subtotal',style: TextStyle(fontSize: 16,color: Color(0xffBBAD92),fontWeight: FontWeight.w800),),),
                      Align(
                        alignment: Alignment.centerRight,
                        child:Text('₹'+order_string[0].order_total,style: TextStyle(fontSize: 16,color: Color(0xffBBAD92),fontWeight: FontWeight.w800),),),
                      //
                    ],
                  ),),
              /*  Container(
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
                      left: 20, top:10, right: 20, bottom: 0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child:Text('Total',style: TextStyle(fontSize: 20,color: theme_color.button_color,fontWeight: FontWeight.w500),),),
                      Text('₹'+order_string[0].order_total,style: TextStyle(fontSize: 20,color:  theme_color.button_color,fontWeight: FontWeight.w500),),
                      //
                    ],
                  ),),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20, top:5, right: 20, bottom: 0),
                  child:Dash(length: 350, dashColor:theme_color.light_grey),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, top: 10, right: 5, bottom: 10),
                  child:  InkWell(
                    onTap: () {

                     repeat_order();


                    },
                    child:Container(
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          left: 25,
                          top: 20,
                          right: 20,
                          bottom: 0),
                      padding: const EdgeInsets.only(
                          left: 5, top: 10, right: 5, bottom: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [theme_color.dark_green,theme_color.dark_green]),
                        border: Border.all(
                            color: theme_color.texbox_background, // set border color
                            width: 0.5), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(
                                30.0)), // set rounded corner radius
                        // make rounded corner of border
                      ),
                      child: Text(
                        'REPEAT ORDER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, top: 10, right: 5, bottom: 20),
                  child:  InkWell(
                    onTap: () {

                    /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppDrawer(
                              child: Home(),
                            ),
                          ));*/
                      launchUrl('${Urllink.Invoice_Link+widget.order_id}');



                    },
                    child:Container(
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          left: 25,
                          top: 5,
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
                        'DOWNLOAD INVOICE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                ),
                if(order_string[0].rating=='0'&&order_string[0].order_status=='Delivered')...[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5, top: 5, right: 5, bottom: 20),
                    child:  InkWell(
                      onTap: () {

                        showRatingDialog();

                      },
                      child:Container(
                        alignment: Alignment.center,
                        height: 60,
                        margin: const EdgeInsets.only(
                            left: 25,
                            top: 5,
                            right: 20,
                            bottom: 10),
                        padding: const EdgeInsets.only(
                            left: 5, top: 10, right: 5, bottom: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [theme_color.red,theme_color.red]),
                          border: Border.all(
                              color: theme_color.texbox_background, // set border color
                              width: 0.5), // set border width
                          borderRadius: BorderRadius.all(
                              Radius.circular(
                                  30.0)), // set rounded corner radius
                          // make rounded corner of border
                        ),
                        child: Text(
                          'RATE THIS ORDER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                  ),
                ]


              ],
            ),

          ),

        ),

      ],
    );

  }
  void showRatingDialog() {
    final ratingDialog = RatingDialog(
      message: Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, ');
        print('comment: ${response.comment}');
        submit_rating('${response.rating}','${response.comment}');
      }, submitButtonText: 'Submit',
      title: Text(
        'Rate this order',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ratingDialog,
    );
  }
  static void launchUrl(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  submit_rating(String rating,String comment) async {
    var url = Urllink.submit_rating;
    String user_id = await prefs.ismember_id();

    final response = await http.post(Uri.parse(url), body: {"order_id": widget.order_id,"user_id": user_id,"rating": rating,"review": comment});

    Map<String, dynamic> datauser = json.decode(response.body);
    print("datauser ::  ${datauser}");

    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          Fluttertoast.showToast(
              msg: "Rating submitted successfully.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.dark_green,
              textColor: theme_color.black,
              fontSize: 15.0);

        });
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: "Something went wrong.please try again.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: theme_color.red,
              textColor: theme_color.black,
              fontSize: 15.0);
        });

      }
    }


  }
  repeat_order() async {
    showLoaderDialog(context);
    final url = Urllink.repeat_order;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "order_id": widget.order_id,
      "user_id": user_id,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      if(datauser['status']=='0')
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => cart()),
          );

        }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>cart()),
        );

      }

    }
    else{
      Navigator.pop(context);
    }
  }

  get_my_order() async {
     showLoaderDialog(context);
    final url = Urllink.get_order_data;
    http.Response response = await http.post(Uri.parse(url),  body: {
      "order_id": widget.order_id,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);

      print("order_string${datauser}");


      setState(() {
        orderlist = datauser['data'] as List;
        order_string = orderlist.map<order_list_model>(
                (json) => order_list_model.fromJson(json)).toList();
        print("order_string[0].rating${order_string[0].rating}");
      });

    }
    else{
      Navigator.pop(context);
    }
  }
  get_order_detail() async {
    // showLoaderDialog(context);
    print('order_Detail called');

    final url = Urllink.get_order_detail;
    http.Response response = await http.post(Uri.parse(url),  body: {
      "order_id": widget.order_id,

    });
    print('response.statusCode${widget.order_id}');

    if (response.statusCode == 200) {
      //Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        productlist = datauser['data'] as List;
        product_string = productlist.map<product_list>(
                (json) => product_list.fromJson(json)).toList();
      });
      print('product_string${product_string}');

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
