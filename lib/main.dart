// ignore_for_file: prefer_const_constructors

import 'package:bitza_app/cart_provider.dart';
import 'package:bitza_app/screen/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_)=>CartProvider(),
        child:Builder(builder: (BuildContext context){
          return MaterialApp(
            title: 'Shopping',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              // primaryColor: Colors.redAccent,
              // visualDensity: VisualDensity.adaptivePlatformDensity
            ),
            home: ProductListScreen(),

          );
        },) ,
    );
  }
}




