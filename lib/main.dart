import 'package:flutter/material.dart';
import 'package:dumdumcard/pages/menu.dart';
import 'package:dumdumcard/pages/loading.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: './menu',
    routes: {
      '.':(context) => const Loading(),
      './menu': (context) =>  const MyApp(),
    },
  ));
}