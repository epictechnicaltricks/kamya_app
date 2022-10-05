import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dash/flutter_dash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/Model/shopping_list.dart';
import 'package:kamya_app/add_address.dart';
import 'package:kamya_app/add_shopping_list.dart';
import 'package:kamya_app/list_product.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:kamya_app/product_detail.dart';
import 'package:kamya_app/shopping_list_product.dart';
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

class product extends StatefulWidget {
  String category_id;
  product(this.category_id);

  @override
  _productState createState() => _productState();
}
class _productState extends State<product> {
  int _selected_varient=0;
  List cartlist = [];
  List<cart_list> cart_string = [];

  List varientlist = [];
  List<varient_data> varient_string = [];

  List shoppinglist = [];
  List<shopping_list_model> shopping_string = [];

  String empty_list='0';

  Prefs prefs = new Prefs();
  String dropdownValue = 'Select Varient';
  List productlist =  [];
  List<product_list> product_string = [];
  List dropdown =  [];
  List selected_varient =  [];

  String radioButtonItem = 'Home';
  late String status;
  int id = 1;
  int quantity=0;
  TextEditingController search_product = new TextEditingController();
  List<TextEditingController> _quantityController = [];
  List varient_price =[];
  List visible= [];
  List add_to_cart_visible= [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_product();
      this.get_cart();
      this.get_shopping_list();
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
                  padding: const EdgeInsets.only(left: 0, top:0, right: 0, bottom: 80),
                  child:ListView.builder(
                    key: UniqueKey(),
                    itemCount: product_string.length,
                    itemBuilder: (context, i) {
                      return Padding( padding: EdgeInsets.only(left: 23.0),

                        child: Row(
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
                                          MaterialPageRoute(builder: (context) => product_detail( product_string[i].product_id)),
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
                                          product_string[i].product_img,
                                          height: 10,
                                          width: 10,
                                          // fit: BoxFit.fill,
                                        ),
                                      ),

                                    ),

                                    Container(
                                      width:275,
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
                                                    //   MaterialPageRoute(builder: (context) => product_detail( product_string[i].product_id)),
                                                    MaterialPageRoute(builder: (context) => product_detail( product_string[i].product_id)),
                                                  );



                                                },
                                                child:
                                                Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 0, top: 10, right: 0, bottom: 5),

                                                  margin: const EdgeInsets.only(
                                                      left: 20, top:5, right: 2, bottom: 0),
                                                  child:Text(
                                                    product_string[i].product_name,
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
                                                  _product_varient(i,product_string[i].product_id);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 0, top: 2, right: 0, bottom: 2),
                                                  margin: const EdgeInsets.only(
                                                      left: 20, top: 0, right: 4, bottom: 0),

                                                  child:Wrap(
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    children: [
                                                      Text(dropdown[i],
                                                        style: TextStyle(color: Colors.grey,
                                                            fontSize: 15),
                                                      ), Icon(Icons.keyboard_arrow_down_outlined,
                                                        color: Colors.grey,),
                                                    ],
                                                  ),



                                                  /* Text(
                                      product_string[i].varient_name+','+ product_string[i].varient_price,
                                      style: TextStyle(color: Colors.grey,
                                      fontSize: 13),
                                    ),*/
                                                  // _product_varient(context),
                                                ),

                                              ),
                                              Visibility(
                                                  visible:visible[i],
                                                  child:
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.transparent,
                                                          radius: 20,
                                                          child:  IconButton(
                                                            icon: Icon(Icons.remove,color: _quantityController[i].text!="1"?theme_color.dark_green:theme_color.light_grey,),
                                                            onPressed: () {
                                                              _removeQuantity(i,product_string[i].varient_id,product_string[i].product_id);
                                                            },
                                                          ),
                                                        ),
                                                        decoration: new BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: new Border.all(
                                                            color: _quantityController[i].text!="1"?theme_color.dark_green:theme_color.light_grey,
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
                                                              controller: _quantityController[i],
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
                                                            icon: Icon(Icons.add,color:theme_color.dark_green),
                                                            onPressed: () {
                                                              _addQuantity(i,product_string[i].varient_id,product_string[i].product_id);
                                                            },
                                                          ),
                                                        ),
                                                        decoration: new BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: new Border.all(
                                                            color:theme_color.dark_green,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  )

                                              ),
                                            ],
                                          ),


                                          if(product_string[i].product_status=='In stock')...[
                                            Row(
                                              children:<Widget>[
                                                Visibility(
                                                  visible:add_to_cart_visible[i],
                                                  child:


                                                  Container(

                                                    margin: EdgeInsets.only(left: 25),
                                                    child : ElevatedButton(
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

                                                        add_to_cart(selected_varient[i],product_string[i].product_id,i);


                                                      },
                                                    ),
                                                  ),),



                                                Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 0, top: 5, right: 0, bottom: 5),
                                                  margin: const EdgeInsets.only(
                                                      left: 20, top: 0, right: 4, bottom: 0),

                                                  child: Text(
                                                    'Rs.'+varient_price[i],
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: theme_color.button_color,
                                                      fontSize: 15,
                                                      //fontFamily: "Quicksand",
                                                      fontWeight: FontWeight.w700,
                                                    ),

                                                  ),
                                                ),

                                                Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 0, top: 0, right: 20, bottom: 0),
                                                  child:GestureDetector(

                                                    onTap: () {
                                                      _showDialog(context, product_string[i].product_id, product_string[i].varient_id);
                                                    },
                                                    child:  Image.asset(
                                                      'assets/shopping-list-active.png',
                                                      height: 20,
                                                      width: 20,
                                                      fit: BoxFit.fill,
                                                    ),

                                                  ),
                                                ),

                                              ],
                                            ),

                                          ],
                      if(product_string[i].product_status=='Out of stock')...[
                        Row(
                          children:<Widget>[
                            Visibility(
                              visible:add_to_cart_visible[i],
                              child:


                              Container(

                                margin: EdgeInsets.only(left: 25),
                                child : ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(theme_color.red),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(
                                          color: theme_color.red,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Text('Out of stock'),
                                  onPressed: () {

                                    //add_to_cart(selected_varient[i],product_string[i].product_id,i);


                                  },
                                ),
                              ),),



                            Container(
                              padding: const EdgeInsets.only(
                                  left: 0, top: 5, right: 0, bottom: 5),
                              margin: const EdgeInsets.only(
                                  left: 20, top: 0, right: 4, bottom: 0),

                              child: Text(
                                'Rs.'+varient_price[i],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: theme_color.button_color,
                                  fontSize: 15,
                                  //fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w700,
                                ),

                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.only(
                                  left: 0, top: 0, right: 20, bottom: 0),
                              child:GestureDetector(

                                onTap: () {
                                  _showDialog(context, product_string[i].product_id, product_string[i].varient_id);
                                },
                                child:  Image.asset(
                                  'assets/shopping-list-active.png',
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.fill,
                                ),

                              ),
                            ),

                          ],
                        ),

                      ],
                      ],
                                      ),
                                    ),


                                  ],
                                ),
                                Dash(length: MediaQuery.of(context).size.width-70, dashColor:theme_color.light_grey),

                              ],
                            )

                          ],
                        ),);

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
  void _addQuantity(int i,String varient_id,String product_id){
    setState(() {
      int s = int.parse(_quantityController[i].text);
      s++;
      _quantityController[i].text = '$s';
      //update_cart(varient_id,product_id,i);
      add_to_cart( varient_id,product_id, i);
    });
    // update_total();
  }

  void _removeQuantity(int i,String varient_id,String product_id){
    setState(() {
      if(int.parse(_quantityController[i].text) > 1){
        int s = int.parse(_quantityController[i].text);
        s--;
        _quantityController[i].text = '$s';
        update_cart(varient_id,product_id,i);

      }else{
        quantity = 0;
      }
      // update_total();
    });
  }
  _showDialog(context,product_id,varient_id) async{

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
            height: 400,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                empty_list == '0' ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child:Container(
                        margin: const EdgeInsets.only(
                            left: 0, top: 30, right: 0, bottom: 0),
                        height:100,
                        width:100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/shopping-list-active.png"), // <-- BACKGROUND IMAGE
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child:Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                            left: 10, top:20, right: 10, bottom: 10),
                        child: Text(
                          'Your shopping is empty!',
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
                      child:Container(
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
                              builder: (context) => add_shopping_list(),

                            ));

                      },
                      child:Container(
                        alignment: Alignment.center,
                        height: 60,
                        margin: const EdgeInsets.only(
                            left: 25,
                            top: 10,
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
                          'CREATE LIST NOW',
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
                ):
                Container(
                  margin: const EdgeInsets.only(
                      left: 0, top: 1, right: 0, bottom: 0),
                  height: 290,
                  child: ListView.builder(
                      itemCount: shopping_string.length,
                      itemBuilder: (context, i) {
                        return
                          GestureDetector(
                            onTap: () {
                              add_to_list(
                                  varient_id,
                                  product_id,
                                  shopping_string[i].shopping_list_id);
                            },
                            child:       Container(
                              margin:
                              const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
                              width:MediaQuery.of(context).size.width,

                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      theme_color.button_color,
                                      theme_color.button_color
                                    ]),
                                border: Border.all(
                                    color: theme_color.button_color, // set border color
                                    width: 0.5), // set border width
                                borderRadius: BorderRadius.all(
                                    Radius.circular(22.0)), // set rounded corner radius
                                // make rounded corner of border
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => shopping_list_product(shopping_string[i].shopping_list_id,shopping_string[i].list_name),
                                              ));
                                        },
                                        child:
                                        Row(
                                          children: [
                                            Container(
                                                padding:
                                                const EdgeInsets.only(left: 20, top: 10, right: 2, bottom: 2),
                                                child: Text(shopping_string[i].list_name , style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w800,
                                                ),)),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              padding:
                                              const EdgeInsets.only(left: 20, top: 10, right: 2, bottom: 12),
                                              child: Text(shopping_string[i].total+' Items' , style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w400,
                                              ),)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => list_product(shopping_string[i].shopping_list_id,shopping_string[i].list_name),
                                          ));
                                    },
                                    child:     Container(
                                      width:55,
                                      height:55,
                                      padding:
                                      const EdgeInsets.only(left: 15, top:10, right: 15, bottom: 10),
                                      margin:
                                      const EdgeInsets.only(left: 0, top:5, right: 15, bottom: 5),

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
                                      child: Image.asset(
                                        'assets/arrow-right.png',
                                        height: 10,
                                        width: 10,
                                        // fit: BoxFit.fill,
                                      ),
                                    ),

                                  )
                                ],
                              ),


                            ),


                          );


                      }),
                ),
              ],
            ),
          ),

        );
      },
    );
  }
  add_to_list(String varient_id,String product_id,String list_id) async {
    showLoaderDialog(context);
    final url = Urllink.add_to_list;
    String qty='1';
    String user_id=await prefs.ismember_id();
    http.Response response = await http.post(Uri.parse(url),  body: {
      "varient_id": varient_id,
      "qty":qty,
      "product_id":product_id,
      "user_id":user_id,
      "list_id":list_id

    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      //  print(datauser['data']);

      setState(() {
        //_showDialog_product(context);
        Fluttertoast.showToast(
            msg: "Product Added To List ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.white,
            fontSize: 15.0);
      });
      Navigator.pop(context);
    }
    else{
      Navigator.pop(context);

    }
    get_cart();
    get_shopping_list();
  }

  get_shopping_list() async {
    var url = Urllink.get_shopping_list;
    String user_id = await prefs.ismember_id();
    final response = await http.post(Uri.parse(url),
        body: {
          "user_id": user_id,
        });

    Map<String, dynamic> datauser = json.decode(response.body);
    print(datauser);
    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          shoppinglist = datauser['data'] as List;
          shopping_string = shoppinglist.map<shopping_list_model>(
                  (json) => shopping_list_model.fromJson(json)).toList();
          if (shopping_string.length != 0)
          {
            empty_list='1';
          }

        });
      } else {
        setState(() {

        });

      }

    }
  }

  get_cart() async {
    // showLoaderDialog(context);
    final url = Urllink.get_user_cart;
    String user_id = await prefs.ismember_id();

    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,

    });
    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        cartlist = datauser['data'] as List;
        // print(cartlist);
        cart_string = cartlist.map<cart_list>(
                (json) => cart_list.fromJson(json)).toList();

      });
    }
  }
  add_to_cart(String varient_id,String product_id,int i) async {
    // showLoaderDialog(context);
    final url = Urllink.add_cart;
    String qty=_quantityController[i].text;
    String user_id=await prefs.ismember_id();
    http.Response response = await http.post(Uri.parse(url),  body: {
      "varient_id": varient_id,
      "qty":qty,
      "product_id":product_id,
      "user_id":user_id

    });


    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      //  print(datauser['data']);

      setState(() {
        //_showDialog_product(context);
        Fluttertoast.showToast(
            msg: "Product Added To Cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.white,
            fontSize: 15.0);
      });
      visible[i]=true;
      add_to_cart_visible[i]=false;

    }
    else{
      // Navigator.pop(context);

    }
    get_cart();
  }

  update_cart(String varient_id,String product_id,int i) async {
    // showLoaderDialog(context);
    final url = Urllink.update_cart;
    String qty=_quantityController[i].text;
    String user_id=await prefs.ismember_id();
    http.Response response = await http.post(Uri.parse(url),  body: {
      "varient_id": varient_id,
      "qty":qty,
      "product_id":product_id,
      "user_id":user_id

    });

    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      //  print(datauser['data']);

      setState(() {
        //_showDialog_product(context);
        Fluttertoast.showToast(
            msg: "Product Added To Cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.white,
            fontSize: 15.0);
      });
      visible[i]=true;
      add_to_cart_visible[i]=false;

    }
    else{
      // Navigator.pop(context);

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
    set_qty(product_string);
  }


  get_product() async {
    showLoaderDialog(context);
    final url = Urllink.get_product;
    String category_id=widget.category_id;
    http.Response response = await http.post(Uri.parse(url),  body: {
      "category_id": category_id,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      //Map<String, dynamic> datauser = json.decode(response.body);
      var datauser = jsonDecode(response.body);
      print('varient_data${datauser}');
      setState(() {
        productlist = datauser['data'] as List;
        product_string = productlist.map<product_list>(
                (json) => product_list.fromJson(json)).toList();

      });

    }
    set_qty(product_string);
  }
  set_qty(List productstring) {
    dropdown = List<String>.filled(productstring.length,productstring[0].varient_name);
    selected_varient = List<String>.filled(productstring.length,productstring[0].varient_id);
    varient_price = List<String>.filled(productstring.length,productstring[0].varient_price, growable: true);

    for (var i = 0; i < productstring.length; i++) {

      print('0product_string${productstring[i].varient_name}');
      _quantityController.add(new TextEditingController());
      _quantityController[i].text = '1';
      dropdown[i] =productstring[i].varient_name;
      selected_varient[i]=productstring[i].varient_id;
      varient_price[i]=productstring[i].varient_price;
      visible = List.filled(productstring.length,false, growable: true);
      add_to_cart_visible=List.filled(productstring.length,true, growable: true);
    }
  }
  _product_varient(i,product_id) async {
    print('product_id${product_id}');
    print('product_ii${i}');
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
          title: Text('Available Quantities'),
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
                        itemBuilder: (context, int j) {
                          return
                            GestureDetector(
                              onTap:(){
                                Navigator.of(context).pop();
                                setState(() {
                                  print('selected_varient${j}${varient_string[j].varient_name}');
                                  selected_varient[i]=varient_string[j].varient_id;
                                  dropdown[i]=varient_string[j].varient_name;
                                  varient_price[i]=varient_string[j].varient_price;
                                  add_to_cart_visible[i]=true;
                                  visible[i]=false;
                                });
                              },
                              child:    Container(
                                height: 50,
                                margin: EdgeInsets.only(bottom: 7),
                                padding: EdgeInsets.only(top: 7,left: 10),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('${varient_string[j].varient_name} - '),
                                    ),
                                    Center(child: Text('₹${varient_string[j].varient_mrp} ', style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey)),),
                                    Align(alignment: Alignment.centerRight,
                                        child:Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('- ₹${varient_string[j].varient_price}', style: TextStyle(fontWeight: FontWeight.w700)),
                                        )),
                                  ],
                                ),



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
