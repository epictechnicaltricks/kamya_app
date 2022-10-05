import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  final  _LoggedIn = "_LoggedIn";
  final  phone_num = "phone_num";
  final  fname = "fname";
  final  user_name = "user_name";
  final  _member_id = "_member_id";
  final  discount = "discount";
  final  coupon = "coupon";

  Future<String> get_coupon() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(coupon) ?? '0';
  }

  Future<bool> set_coupon(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(coupon, value);
  }



  Future<String> get_discount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(discount) ?? '0';
  }

  Future<bool> set_discount(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(discount, value);
  }

  Future<String> isuser_name() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(user_name) ?? 'Guest';
  }

  Future<bool> setuser_name(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(user_name, value);
  }



logout() async{
  final pref = await SharedPreferences.getInstance();
  await pref.clear();
}

    getAllPrefsClear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("_LoggedIn");
  }



  Future<String> ismember_id() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_member_id) ?? '0';
  }

  Future<bool> setmember_id(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_member_id, value);
  }


  //-------------------Login id ------------------------//

  Future<String> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_LoggedIn) ?? '0';
  }

  Future<bool> setLoggedIn(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_LoggedIn, value);
  }

  //----------------- phone_num----------------------//

  Future<String> isphone_num() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(phone_num) ?? '0';
  }

  Future<bool> setphone_num(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(phone_num, value);
  }

  Future<String> isfname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(fname) ?? 'Guest';
  }

  Future<bool> setfname(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(fname, value);
  }


}
