// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:bitza_app/cart_model.dart';
import 'package:bitza_app/cart_provider.dart';
import 'package:bitza_app/helper/database_helper.dart';
import 'package:bitza_app/screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DbHelper ? dbHelper=DbHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'peach',
    'Mixed Fruit Basket'
  ];
  List<String> productUnit = [
    'kg',
    'Dozen',
    'kg',
    'kg',
    'kg',
    'kg',
  ];
  List<int> productPrice = [20, 10, 10, 10, 15, 30];
  List<String> productImage = [
    'images/mango1.jpg',
    'images/orange.jpg',
    'images/grapes.jpg',
    'images/banana.jpg',
    'images/peach.jpg',
    'images/mixedFruit.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child: Center(
              child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                child: Icon(Icons.shopping_bag_outlined),
                animationDuration: Duration(milliseconds: 300),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(
                                  height: 100,
                                  width: 100,
                                  image: AssetImage(
                                      productImage[index].toString()),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName[index].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        productUnit[index].toString() +
                                            " " +
                                            "\$" +
                                            productPrice[index].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: (){
                                            dbHelper!.insertCart(Cart(
                                                id: index,
                                                productId: index.toString(),
                                                productName: productName[index].toString(),
                                                productPrice: productPrice[index],
                                                initialPrice: productPrice[index],
                                                quantity: 1,
                                                unitTag: productUnit[index].toString(),
                                                image: productImage[index].toString(),
                                            ),
                                            ).then((value) {
                                              print('product is added to cart');
                                              cart.addTotalPrice(double.parse( productPrice[index].toString()));
                                              cart.addCounter();
                                            }).onError((error, stackTrace){
                                              print(error.toString());
                                            });

                                          },
                                          child: Container(
                                            height: 35.0,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                            ),
                                            child: Center(
                                              child: Text('Add to cart',style: TextStyle(color: Colors.white),),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),

        ],
      ),
    );
  }
}



