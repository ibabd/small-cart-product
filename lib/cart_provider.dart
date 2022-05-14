// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:bitza_app/cart_model.dart';
import 'package:bitza_app/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CartProvider extends ChangeNotifier{
  DbHelper dbHelper=DbHelper();
  int _counter=0;
  int get counter=>_counter;
  double _totalPrice=0.0;
  double get totalPrice=>_totalPrice;
  late Future<List<Cart>>_cart;
  Future<List<Cart>> get cart=>_cart;
  Future<List<Cart>> getData()async{
     _cart=dbHelper.getCartList();
     return _cart;
  }


  void _setPrefItems()async{
    SharedPreferences prefs=SharedPreferences.getInstance() as SharedPreferences;
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }
  void _getPrefItems()async{
    SharedPreferences prefs=SharedPreferences.getInstance() as SharedPreferences;
    _counter=prefs.getInt('cart_item')?? 0 ;
    _totalPrice=prefs.getDouble('total_price')?? 0.0;
    notifyListeners();
  }
  addCounter(){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }
  removeCounter(){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }
  int getCounter(){
    _getPrefItems();
    return _counter;
  }
  addTotalPrice(double productPrice){
   _totalPrice+=productPrice;
    _setPrefItems();
    notifyListeners();
  }
  RemoveTotalPrice(double productPrice){
    _totalPrice-=productPrice;
    _setPrefItems();
    notifyListeners();
  }
  double getTotalPrice(){
    _getPrefItems();
    return _totalPrice;
  }

}