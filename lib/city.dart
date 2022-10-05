import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kamya_app/theme_color.dart';
import 'package:http/http.dart' as http;
import 'Model/city.dart';
import 'Urllink.dart';
import 'home.dart';
class city extends StatefulWidget {
  @override
  _cityState createState() => _cityState();
}
class _cityState extends State<city> {
  List city_list = [];
  List<City_list> city_string = [];

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Stack( // <-- STACK AS THE SCAFFOLD PARENT
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
          body:      Column(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child:Container(
                          margin: const EdgeInsets.only(
                              left: 0, top: 150, right: 0, bottom: 0),
                          height:200,
                          width:200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/logo.png"), // <-- BACKGROUND IMAGE
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

    Container(
    margin: const EdgeInsets.only(
    left: 0, top: 2, right: 4, bottom: 0),
    child:_buildFields(context),
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

  Widget _buildFields(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: 0, top: 4, right: 4, bottom: 0),
        child: GridView.count(
          padding: EdgeInsets.all(20),
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(city_string.length, (index) {
            return Center(
              child: new Column(
                children: [
                  new Expanded(
                    child: InkWell(
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 500), ()
                        {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    event(popular_string[index].category_id)),
                          );*/
                        });
                      },
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child:Container(
                          child: new Image.network(
                            city_string[index].city_img,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),

                        ),

                      ),
                    ),
                  ),
                ],
              ),

            );
          }),
        ));
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
