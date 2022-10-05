import 'package:flutter/material.dart';
import 'AppDrawer.dart';

AppBar headerNav(){
  return   AppBar(
    title: Text('Kmaya'),
    leading: Builder(
      builder: (BuildContext appBarContext) {
        return IconButton(
            onPressed: () {
              AppDrawer.of(appBarContext)?.toggle();
            },
            icon: Icon(Icons.menu)
        );
      },
    ),
  );

}