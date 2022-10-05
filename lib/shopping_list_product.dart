import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/add_address.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:kamya_app/product_detail.dart';
import 'package:kamya_app/shopping_list.dart';
import 'dart:convert';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'AppDrawer.dart';
import 'Model/product.dart';
import 'Urllink.dart';
import 'cart.dart';
import 'model/cart.dart';
import 'home.dart';
import 'notifications.dart';

class shopping_list_product extends StatefulWidget {
  String list_id;
  String list_name;
  shopping_list_product(this.list_id,this.list_name);

  @override
  _shopping_list_productState createState() => _shopping_list_productState();
}
class _shopping_list_productState extends State<shopping_list_product> {
  List cartlist = [];
  List<cart_list> cart_string =[];
  Prefs prefs = new Prefs();
  String dropdownValue = 'Select Varient';
  var dropdown = List<String>.filled(5,'Select Varient', growable: true);
  List productlist = [];
  List<product_list> product_string = [];
  String radioButtonItem = 'Home';
  late  String status;
  int id = 1;
  TextEditingController search_product = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      this.get_my_list();
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
            title: Text(widget.list_name),
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
                              hintText: 'Search....',
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
                  padding: const EdgeInsets.only(left: 0, top:0, right: 0, bottom: 125),
                  child:ListView.builder(
                    key: UniqueKey(),
                    itemCount: product_string.length,
                    itemBuilder: (context, index) {
                      dropdown[index]=product_string[index].varient_name;
                      return  Padding(
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
                                          padding:
                                          const EdgeInsets.only(left: 10, top:10, right: 10, bottom: 10),

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
                                        width:270,
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
                                                        left: 20, top:5, right: 4, bottom: 0),
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
                                                    _product_varient(context,index);
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

                                                )


                                              ],
                                            ),
                                            Row(
                                              children:<Widget>[
                                                Container(

                                                  margin: EdgeInsets.only(left: 25),
                                                  child :
                                                  ElevatedButton(

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
                                                    child: Text('Remove'),
                                                    onPressed: () {

                                                      remove_from_list(product_string[index].shopping_list_product_id);


                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 0, top: 5, right: 0, bottom: 5),
                                                  margin: const EdgeInsets.only(
                                                      left: 20, top: 0, right: 4, bottom: 0),

                                                  child: Text(
                                                    'Rs.'+product_string[index].varient_price+'.00',
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
          bottomNavigationBar: GestureDetector(
            onTap: () {
              String list_id = widget.list_id;

                add_to_cart(list_id);


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
                'Add list to cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
  add_to_cart(String list_id) async {
    showLoaderDialog(context);
    String user_id = await prefs.ismember_id();
    final url = Urllink.copy_list_to_cart;

    http.Response response = await http.post(Uri.parse(url),  body: {
      "user_id": user_id,
      "list_id": list_id,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        Fluttertoast.showToast(
            msg: "List added to cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => shopping_list(),
            ));

    });
    }
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
        print(cartlist);
        cart_string = cartlist.map<cart_list>(
                (json) => cart_list.fromJson(json)).toList();

      });
    }
  }
  remove_from_list(String shopping_list_product_id) async {
    showLoaderDialog(context);
    final url = Urllink.remove_from_list;
    http.Response response = await http.post(Uri.parse(url),  body: {
      "shopping_list_product_id": shopping_list_product_id,

    });
    print(response.body);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);

      setState(() {
        //_showDialog_product(context);
        Fluttertoast.showToast(
            msg: "Product Removed From List",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: theme_color.dark_green,
            textColor: theme_color.black,
            fontSize: 15.0);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => shopping_list(),
          ));

    }
    else{
      Navigator.pop(context);

    }
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
  }

  get_my_list() async {
    showLoaderDialog(context);
    final url = Urllink.get_list_product;
    print('Listid${widget.list_id}');
    String list_id=widget.list_id;
    http.Response response = await http.post(Uri.parse(url),  body: {
      "list_id": list_id,

    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Map<String, dynamic> datauser = json.decode(response.body);
      setState(() {
        productlist = datauser['data'] as List;
        product_string = productlist.map<product_list>(
                (json) => product_list.fromJson(json)).toList();
      });

    }
  }
  _product_varient(BuildContext context,index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          // title: new Text("Alert!!"),
          content:Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Container(
                  margin: const EdgeInsets.only(
                      left: 0, top: 1, right: 0, bottom: 0),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    iconSize: 24,
                    style: TextStyle(color: theme_color.black),
                    underline: Container(
                      height: 2,
                      color: theme_color.light_green,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        dropdown[index]=newValue!;
                        Navigator.pop(context);

                      });
                    },
                    items: <String>['Select Varient', '100 Grams', '250 Grams', '1 KG', '2 KG']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(children: [
                          Text(value),

                        ]),
                      );
                    }).toList(),
                  )
              ),
            ],
          ),


        );
      },
    );
  }

  show_varient(BuildContext context,index){
    return  DropdownButton<String>(
      value: dropdown[index],
      icon: Icon(Icons.keyboard_arrow_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: theme_color.black),
      underline: Container(
        height: 2,
        color: theme_color.light_green,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          dropdown[index]=newValue!;
        });
      },
      items: <String>['0','Select Varient', '100 Grams', '250 Grams', '1 KG', '2 KG']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(children: [
            Text(value),

          ]),
        );
      }).toList(),
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
