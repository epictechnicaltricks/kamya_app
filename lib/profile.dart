import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kamya_app/Urllink.dart';
import 'package:kamya_app/prefs_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
//import 'package:permission_handler/permission_handler.dart';

import 'AppDrawer.dart';
import 'home.dart';
import 'login.dart';
//import 'camera.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String f_payment = "";
  Prefs prefs = new Prefs();
  String status = "";
  String profilePic = "";
  late Position _currentPosition;
  String _currentAddress = "";

  String location ='Null, Press Button';
  String Address = 'search';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      print('address${Address}');
    setState(()  {
      location_con.text=Address;
    });
  }


  TextEditingController first_con = new TextEditingController();
  TextEditingController last_con = new TextEditingController();
  TextEditingController mobile_con = new TextEditingController();
  TextEditingController email_con = new TextEditingController();
  TextEditingController pin_con = new TextEditingController();
  TextEditingController location_con = new TextEditingController();

  String _path = "";
  String _path_1 = "";
  late Map<String, String> _paths;

  String _fileName = "";
  String _fileName_1 = "";
  bool _hasValidMime = false;
  bool _loadingPath = false;

  late double _width;
  late double _height;
  late String member_id;

  String user_fname = "";
  String user_lname = "";
  String user_email = "";
  String user_phno = "";
  String country_id = "";
  String user_pic = "";
  String user_pincode = "";

  String use_lang = "";
  String lable_1 = "";
  String lable_2 = "";
  String lable_3 = "";
  String lable_4 = "";
  String lable_5 = "";
  String lable_6 = "";
  String lable_7 = "";
  String lable_8 = "";
  String lable_9 = "";
  String lable_10 = "";
  String lable_11 = "";
  String lable_12 = "";
  String lable_13 = "";
  late String token;
  String Camera="";
  String Gallery="";




  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    Future.delayed(Duration(microseconds: 3), () async {
     this._checkPermission();
      this.getuser_lang();
     getget_profile();
     Position position = await _getGeoLocationPosition();
     location ='Lat: ${position.latitude} , Long: ${position.longitude}';
     GetAddressFromLatLong(position);

      //    this._getCurrentLocation();
    });
  }
  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus.isEnabled;
    if (!isGpsOn) {
      print('Turn on location services before requesting permission.');
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }


  dynamic _image;



  getuser_lang() async {

    print("use_lang :: ${use_lang}");

    if (use_lang == "0") {

      setState(() {

        lable_1 = "Profile";
        lable_2 = "Logout";
        lable_3 = "Phone Number";
        lable_4 = "First name";
        lable_5 = "Last name";
        lable_6 = "Email Address";
        lable_7 = "Update Profile";
        lable_8 = "Please Select Profile Pic";
        lable_9 = "Please Enter First Name";
        lable_10 = "Please Enter Last Name";
        lable_11 = "Please Enter Email Address";
        lable_12 = "Profile Updated Successfully.";
        lable_13 = "Failed to update profile.Please try again.";
        Camera="Camera";
        Gallery="Gallery";
      });

    }else {

      setState(() {

        lable_1 = "حساب تعريفي";
        lable_2 = "تسجيل خروج";
        lable_3 = "رقم التليفون";
        lable_4 = "الاسم الاول";
        lable_5 = "الكنية";
        lable_6 = "عنوان البريد الإلكتروني";
        lable_7 = "تحديث الملف";
        lable_8 = "يرجى تحديد صورة الملف الشخصي";
        lable_9 = "الرجاء إدخال الاسم الأول";
        lable_10 = "الرجاء إدخال الاسم الأخير";
        lable_11 = "الرجاء إدخال عنوان البريد الإلكتروني";
        lable_12 = "تم تحديث الملف الشخصي بنجاح.";
        lable_13 = "فشل تحديث الملف الشخصي. يرجى المحاولة مرة أخرى.";
        Camera="الة تصوير";
        Gallery="صالة عرض";


      });


    }



    this._getPrefsData();


  }

  Future _getPrefsData() async {
    member_id = await prefs.ismember_id();
 //   token = await prefs.isfcm_token();

    setState(() {
      getget_profile();
    });

  }

  getget_profile() async {
    var url = Urllink.get_profile;
    String user_id = await prefs.ismember_id();
    String token='';
    final response = await http.post(Uri.parse(url), body: {"user_id": user_id,"token": token});

    Map<String, dynamic> datauser = json.decode(response.body);
    print("datauser ::  ${datauser}");

    status = datauser["success"];

    if (response.statusCode == 200) {
      if (status == "0") {
        setState(() {
          //  Navigator.pop(context);

          user_fname = datauser['data'][0] ["user_fname"] as String;
          user_lname = datauser['data'][0] ["user_lname"] as String;
          user_email = datauser['data'][0] ["user_email"] as String;
          country_id = datauser['data'][0] ["country_id"] as String;
          user_phno = datauser['data'][0] ["user_phno"] as String;
          user_pic = datauser['data'][0] ["profile_pic"] as String;
          user_pincode=datauser['data'][0] ["user_pincode"] as String;

          first_con.text = user_fname;
          last_con.text = user_lname;
          email_con.text = user_email;
          pin_con.text = user_pincode;

        });
      } else {
        setState(() {
         // Navigator.pop(context);
        });

      }
    }
  }

  Add_Img() {

    if (_fileName_1 != "") {
      return Stack(
        children: <Widget>[
          Container(
            margin:
            const EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 0),
            padding:
            const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    theme_color.button_color,
                    theme_color.button_color
                  ]),
              border: Border.all(
                  color: theme_color.button_color, // set border color
                  width: 0.5), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(50.0)), // set rounded corner radius
              // make rounded corner of border
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Image.file(
                File(_image),
                height: 90,
                width: 90,
                fit: BoxFit.fill,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                //_openFileExplorer();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: 75, top: 15, right: 5, bottom: 0),
              padding:
              const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [theme_color.button_color, theme_color.button_color]),
                border: Border.all(
                    color: theme_color.button_color, // set border color
                    width: 0.5), // set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(30.0)), // set rounded corner radius
              ),
              child: Image.asset(
                'assets/no-pic.png',
                height: 20,
                width: 20,
                color: theme_color.white,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      );
    } else if (user_pic != "") {
      return Stack(
        children: <Widget>[
          Container(
            margin:
            const EdgeInsets.only(left: 0, top: 15, right: 5, bottom: 0),
            padding:
            const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
            height: 105,
            width: 105,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    theme_color.button_color,
                     theme_color.button_color
                  ]),
              border: Border.all(
                  color: theme_color.button_color, // set border color
                  width: 0.5), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(50.0)), // set rounded corner radius
              // make rounded corner of border
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Image.network(
                user_pic,
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                //_openFileExplorer();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: 75, top: 15, right: 5, bottom: 0),
              padding:
              const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [ theme_color.button_color,theme_color.button_color]),
                border: Border.all(
                    color: theme_color.button_color, // set border color
                    width: 0.5), // set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(30.0)), // set rounded corner radius
              ),
              child: Image.asset(
                'assets/edit-green.png',
                height: 20,
                width: 20,
                color: theme_color.white,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      );
    }else  {
      return Stack(
        children: <Widget>[
          Container(
            margin:
            const EdgeInsets.only(left: 0, top: 15, right: 5, bottom: 0),
            padding:
            const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
            height: 105,
            width: 105,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    theme_color.dark_green,
                    theme_color.dark_green
                  ]),
              border: Border.all(
                  color: theme_color.dark_green, // set border color
                  width: 0.5), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(50.0)), // set rounded corner radius
              // make rounded corner of border
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Image.asset(
                'assets/no-pic.png',
                height: 120,
                width: 120,
                fit: BoxFit.fill,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                //_openFileExplorer();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: 75, top: 15, right: 5, bottom: 0),
              padding:
              const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [ theme_color.dark_green,theme_color.dark_green]),
                border: Border.all(
                    color: theme_color.dark_green, // set border color
                    width: 0.5), // set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(30.0)), // set rounded corner radius
              ),
              child: Image.asset(
                'assets/edit-green.png',
                height: 20,
                width: 20,
                color: theme_color.white,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      );
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
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

  edit_profile_API(String f_first,String f_email_con,String f_pin_con) async {



    var uri = Uri.parse(Urllink.edit_profile);

    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = member_id;
    request.fields['first_name'] = f_first;
    request.fields['email'] = f_email_con;
    request.fields['pin_code'] = f_pin_con;

    if (_fileName_1 != "") {
      print("_path ::: ${_fileName_1}");
      request.files.add(await http.MultipartFile.fromPath('profile_pic', _image));
    } else {
      // request.files.add(await http.MultipartFile.fromPath('profile_pic', ""));
    }



    http.Response response =
    await http.Response.fromStream(await request.send());
    print("Result: ${response.statusCode}");

    Map<String, dynamic> datauser = json.decode(response.body);
    status = datauser["success"];
    setState(() {
      // _isLoading = true;
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      if (status == "1") {
        print(json.decode(response.body));

        setState(() {
        //  Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Profile Updated Successfully.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.lightGreen,
              textColor: theme_color. white,
              fontSize: 15.0);
        });

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppDrawer(
                child: Home(),
              ),
            ));

      } else {
        setState(() {
          Navigator.pop(context);
        });
        Fluttertoast.showToast(
            msg: 'Something went wrong.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: theme_color. white,
            fontSize: 15.0);
      }
    } else {
      setState(() {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(
          msg: 'Something went wrong.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: theme_color. white,
          fontSize: 15.0);
    }
  }



  @override
  Widget build(BuildContext context) {

    return Stack( // <-- STACK AS THE SCAFFOLD PARENT
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/profile_bg.jpg"), // <-- BACKGROUND IMAGE
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
        // title: Text("Profile"),
         leading: new IconButton(
           icon: new Icon(Icons.arrow_back, color: Colors.white),
           onPressed: () => Navigator.of(context).pop(),
         ),
       ),
       body: Column(
          children: <Widget>[
            Center(
              child:Container(
                margin: const EdgeInsets.only(
                    left: 0, top: 2, right: 0, bottom: 0),
                height:140,
                width:140,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo.png"), // <-- BACKGROUND IMAGE
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                   /* Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                          left: 35, top: 10, right: 35, bottom: 0),
                      child: Add_Img(),
                    ),*/

                    Container(
                      margin: const EdgeInsets.only(
                          left: 15, top: 35, right: 5, bottom: 5),
                      padding: const EdgeInsets.only(
                          left: 5, top: 10, right: 5, bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(
                                left: 15, top: 10, right: 10, bottom: 0),
                            child: Text(
                              'Profile' ,
                              style: TextStyle(
                                color: theme_color.button_color,
                                fontSize: 22,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(

                              height:77,
                              child:Row(
                                children: <Widget>[
                                  Container(
                                    child:Image.asset(
                                      'assets/call-icon.png',
                                      height: 18,
                                      width: 18,
                                      fit: BoxFit.fill,
                                    ),

                                    margin: const EdgeInsets.only(
                                        left: 20, top: 10, right: 4, bottom: 0),
                                    padding: const EdgeInsets.all(15),
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                      color: theme_color.light_grey,

                                      ),
                                  ),


                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:<Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 10, right: 0, bottom: 0),

                                            margin: const EdgeInsets.only(
                                                left: 20, top:5, right: 4, bottom: 0),
                                            child:Text(
                                              'Name',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: theme_color.black,
                                                fontSize: 15,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children:<Widget>[
                                          Container(
                                            width: 250.0,
                                            height:40,
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 0, right: 0, bottom: 5),
                                            margin: const EdgeInsets.only(
                                                left: 20, top: 0, right: 4, bottom: 0),
                                            child:
                                              TextField(
                                              decoration: InputDecoration(hintText: 'Enter Name',
                                              counterText: ''),
                                                controller: first_con,
                                                style: new TextStyle(
                                                color: theme_color.black,
                                                fontSize: 16,
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
                          ),

                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(

                              height:77,
                              child:Row(
                                children: <Widget>[
                                  Container(
                                    child:Image.asset(
                                      'assets/email.png',
                                      height: 15,
                                      width: 15,
                                      fit: BoxFit.fill,
                                    ),

                                    margin: const EdgeInsets.only(
                                        left: 20, top: 10, right: 4, bottom: 0),
                                    padding: const EdgeInsets.all(15),
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                      color: theme_color.light_grey,
                                      ),
                                  ),


                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:<Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 10, right: 0, bottom: 0),

                                            margin: const EdgeInsets.only(
                                                left: 20, top:10, right: 4, bottom: 0),
                                            child:Text(
                                              'Email Address',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: theme_color.black,
                                                fontSize: 15,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children:<Widget>[
                                          Container(
                                            width: 250.0,
                                            height:39,
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 0, right: 0, bottom: 5),
                                            margin: const EdgeInsets.only(
                                                left: 20, top: 0, right: 4, bottom: 0),
                                            child:
                                            TextField(
                                              controller: email_con,
                                              decoration: InputDecoration(hintText: 'Enter Email Address',
                                                  counterText: ''),
                                              style: new TextStyle(
                                                color: theme_color.black,
                                                fontSize: 16,
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
                          ),
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(

                              height:77,
                              child:Row(
                                children: <Widget>[
                                  Container(
                                    child:Image.asset(
                                      'assets/pincode.png',
                                      height: 15,
                                      width: 15,
                                      fit: BoxFit.fill,
                                    ),

                                    margin: const EdgeInsets.only(
                                        left: 20, top: 10, right: 4, bottom: 0),
                                    padding: const EdgeInsets.all(15),
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                      color: theme_color.light_grey,
                                     ),
                                  ),


                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:<Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 10, right: 0, bottom: 5),

                                            margin: const EdgeInsets.only(
                                                left: 20, top:5, right: 4, bottom: 0),
                                            child:Text(
                                              'Pin Code',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(

                                                color: theme_color.black,
                                                fontSize: 15,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children:<Widget>[
                                          Container(
                                            width: 250.0,
                                            height:39,
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 0, right: 0, bottom: 5),
                                            margin: const EdgeInsets.only(
                                                left: 20, top: 0, right: 4, bottom: 0),
                                            child:
                                            TextField(
                                              controller: pin_con,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(hintText: 'Enter Pin Code',
                                                  counterText: ''),
                                              style: new TextStyle(
                                                fontFamily: "Roboto",
                                                color: theme_color.black,
                                                fontSize: 16,
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
                          ),
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(

                              height:77,
                              child:Row(
                                children: <Widget>[
                                  Container(
                                    child:Image.asset(
                                      'assets/pincode.png',
                                      height: 15,
                                      width: 15,
                                      fit: BoxFit.fill,
                                    ),

                                    margin: const EdgeInsets.only(
                                        left: 20, top: 10, right: 4, bottom: 0),
                                    padding: const EdgeInsets.all(15),
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                      color: theme_color.light_grey,
                                    ),
                                  ),


                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:<Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 10, right: 0, bottom: 5),

                                            margin: const EdgeInsets.only(
                                                left: 20, top:5, right: 4, bottom: 0),
                                            child:Text(
                                              'Location',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(

                                                color: theme_color.black,
                                                fontSize: 15,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children:<Widget>[
                                          Container(
                                            width: 250.0,
                                            height:59,
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 0, right: 0, bottom: 5),
                                            margin: const EdgeInsets.only(
                                                left: 20, top: 0, right: 4, bottom: 0),
                                            child:
                                            TextField(
                                              controller: location_con,
                                              decoration: InputDecoration(hintText: 'Enter Location',
                                                  counterText: ''),
                                              style: new TextStyle(
                                                fontFamily: "Roboto",
                                                color: theme_color.black,
                                                fontSize: 16,
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
                          ),
                          Container(
                            child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                /*  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: () {
                                        String f_first = first_con.text;
                                        String f_pincode_con = pin_con.text;
                                        String f_email_con = email_con.text;

                                        if (f_first == "") {
                                          Fluttertoast.showToast(
                                              msg: lable_9,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: theme_color. white,
                                              fontSize: 15.0);
                                        } else if (f_email_con == "") {
                                          Fluttertoast.showToast(
                                              msg: lable_11,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: theme_color. white,
                                              fontSize: 15.0);
                                        } else if (f_pincode_con == "") {
                                          Fluttertoast.showToast(
                                              msg: 'Enter Pincode',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: theme_color. white,
                                              fontSize: 15.0);
                                        } else {
                                          edit_profile_API(f_first, f_pincode_con, f_email_con);
                                        }
                                      //  _showDialog(context);

                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 60,
                                        width:140,
                                        margin: const EdgeInsets.only(
                                            left: 5, top: 25, right: 25, bottom: 25),
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 0, right: 5, bottom: 0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                theme_color.button_color,
                                                theme_color.button_color
                                              ]),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(35.0)),
                                        ),
                                        child: Text(
                                          'NEXT' ,
                                          style: TextStyle(
                                            color: theme_color.white,
                                            fontSize: 16,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),*/
                                  InkWell(
                                      onTap: () {
                                        String f_first = first_con.text;
                                        String f_email_con = email_con.text;
                                        String f_pincode_con = pin_con.text;

                                        if (f_first == "") {
                                          Fluttertoast.showToast(
                                              msg: 'Enter Name',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: theme_color. white,
                                              fontSize: 15.0);
                                        } else if (f_email_con == "") {
                                          Fluttertoast.showToast(
                                              msg: 'Enter Email',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: theme_color. white,
                                              fontSize: 15.0);
                                        }
                                        else if (f_pincode_con == "") {
                                          Fluttertoast.showToast(
                                              msg: 'Enter Pincode',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: theme_color. white,
                                              fontSize: 15.0);
                                        } else {
                                          edit_profile_API(f_first, f_email_con, f_pincode_con);
                                        }
                                       // _showErrorDialog(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 60,
                                        width:330,

                                        margin: const EdgeInsets.only(
                                            left: 5, top: 25, right: 25, bottom: 25),
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 0, right: 5, bottom: 0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                theme_color.dark_green,
                                                theme_color.dark_green
                                              ]),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(35.0)),
                                        ),
                                        child: Text(
                                          'SUBMIT' ,
                                          style: TextStyle(
                                            color: theme_color.white,
                                            fontSize: 16,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),


                                ]

                            )
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    ],
    );

  }


  void _showDialog(BuildContext context) {
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
              height:200,
              width:200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/product-list-success.png"), // <-- BACKGROUND IMAGE
                ),
              ),
            ),
                Container(
                    child:Text(
                      'Item Successfully added to shopping list',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w800,
                      ),
                    )
                ),
                InkWell(
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
  void _showErrorDialog(BuildContext context) {
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
                height:200,
                width:200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/loaction-error.png"), // <-- BACKGROUND IMAGE
                  ),
                ),
              ),
              Container(
                  child:Text(
                    'Your Pincode is out of delivery area of Kamya',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w800,
                    ),
                  )
              ),
              InkWell(
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(),
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
                  'CHANGE PINCODE',
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


}

