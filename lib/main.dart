import 'package:flutter/material.dart';
import 'package:dumdumcard/pages/loading.dart';
import 'package:dumdumcard/pages/screen.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '.',
    routes: {
      '.':(context) => const Loading(),
      './screen': (context) =>  const Screen()
    },
  ));
}