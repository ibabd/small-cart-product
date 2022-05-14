// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_adjacent_string_concatenation

import 'package:badges/badges.dart';
import 'package:bitza_app/cart_model.dart';
import 'package:bitza_app/cart_provider.dart';
import 'package:bitza_app/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    DbHelper dbHelper = DbHelper();
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Product'),
        centerTitle: true,
        actions: [
          Center(
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
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {

                    if(snapshot.data!.isEmpty){
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('images/cart_empty.jpg'),
                            SizedBox(height: 20,),
                            Text(' Cart is Empty',style: Theme.of(context).textTheme.headline6,),
                          ],
                        ),
                      );

                    }else{
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image(
                                            height: 100,
                                            width: 100,
                                            image: AssetImage(snapshot
                                                .data![index].image
                                                .toString()),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data![index].productName
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          dbHelper.delete(snapshot
                                                              .data![index].id!);
                                                          cart.removeCounter();
                                                          cart.RemoveTotalPrice(
                                                              double.parse(snapshot
                                                                  .data![index]
                                                                  .productPrice
                                                                  .toString()));
                                                        },
                                                        child: Icon(Icons.delete)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  snapshot.data![index].unitTag
                                                      .toString() +
                                                      " " +
                                                      "\$" +
                                                      snapshot
                                                          .data![index].productPrice
                                                          .toString(),
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
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 35.0,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                int quantity = snapshot.data![index].quantity!;
                                                                int price = snapshot.data![index].initialPrice!;
                                                                quantity--;
                                                                int? newPrice=price*quantity;
                                                                if(quantity >0){
                                                                  dbHelper.updateQuantity(
                                                                    Cart(
                                                                      id: snapshot.data![index].id,
                                                                      productId: snapshot.data![index].productId,
                                                                      productName: snapshot.data![index].productName.toString(),
                                                                      productPrice: newPrice,
                                                                      initialPrice: snapshot.data![index].initialPrice!,
                                                                      quantity: quantity,
                                                                      unitTag: snapshot.data![index].unitTag.toString(),
                                                                      image: snapshot.data![index].image.toString(),
                                                                    ),
                                                                  ).then((value) {
                                                                    newPrice=0;
                                                                    quantity=0;
                                                                    cart.RemoveTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                  }).onError((error, stackTrace) {
                                                                    print(error.toString());
                                                                  });
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors.white,
                                                              )),
                                                          Text(
                                                            snapshot.data![index]
                                                                .quantity
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white),
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                int quantity = snapshot.data![index].quantity!;
                                                                int price = snapshot.data![index].initialPrice!;
                                                                quantity++;
                                                                int? newPrice=price*quantity;
                                                                dbHelper.updateQuantity(
                                                                  Cart(
                                                                    id: snapshot.data![index].id,
                                                                    productId: snapshot.data![index].productId,
                                                                    productName: snapshot.data![index].productName.toString(),
                                                                    productPrice: newPrice,
                                                                    initialPrice: snapshot.data![index].initialPrice!,
                                                                    quantity: quantity,
                                                                    unitTag: snapshot.data![index].unitTag.toString(),
                                                                    image: snapshot.data![index].image.toString(),
                                                                  ),
                                                                ).then((value) {
                                                                  newPrice=0;
                                                                  quantity=0;
                                                                  cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                }).onError((error, stackTrace) {
                                                                  print(error.toString());
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Colors.white,
                                                              )),
                                                        ],
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
                            }),
                      );
                    }

                  }
                  return Text('');
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                    ? false
                    : true,
                child: Column(
                  children: [
                    ReusableWidget(
                      title: 'Sub Total',
                      value: '\$' + value.getTotalPrice().toStringAsFixed(2),
                    ),
                    ReusableWidget(
                      title: 'Discount 5%',
                      value: r'$' + '20',
                    ),
                    ReusableWidget(
                      title: 'Sub Total',
                      value: '\$' + value.getTotalPrice().toStringAsFixed(2),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  // ignore: prefer_const_constructors_in_immutables
  ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
