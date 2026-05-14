import 'package:flutter/material.dart';
import './view/bisiesto.view.dart';
import './controller/bisiesto.controller.dart';

void main (){
  runApp(BisiestoApp());
}

class BisiestoApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Anio Bisiesto",
      theme: ThemeData(primaryColor: Colors.blue),
      home: BisiestoPage(),
    );
  }



}