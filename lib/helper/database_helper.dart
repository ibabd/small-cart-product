
import 'dart:async';

import 'package:bitza_app/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper{
  static Database? _db;
  Future<Database ?>get db async{
    if(_db !=null){
      return _db;
    }else{
      _db =await initDb();
      return _db;
    }
  }

  initDb()async {
    var documentDirectory=await getApplicationDocumentsDirectory();
    String path=join(documentDirectory.path,'cart.db');
    var db=await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  FutureOr<void> _onCreate(Database db, int version)async {
    await db.execute('''
    CREATE TABLE cart (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    productId VARCHAR UNIQUE,
    productName TEXT,
    initialPrice INTEGER,
    productPrice INTEGER,
    quantity INTEGER,
    unitTag TEXT,
    image TEXT)
    ''');
  }
  Future<Cart>insertCart(Cart cart)async{
    var dbClient=await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>>getCartList()async{
    var dbClient=await db;
    final List<Map<String,Object?>>queryResult=await dbClient!.query('cart');
    return queryResult.map((e) =>Cart.fromMap(e)).toList();
  }
  Future<int> delete(int id)async{
    var dbClient=await db;
    return await dbClient!.delete(
        'cart',
        where: 'id = ?',whereArgs: [id]
    );
  }
  Future<int> updateQuantity(Cart cart)async{
    var dbClient=await db;
    return await dbClient!.update(
        'cart',
         cart.toMap(),
        where: 'id = ?',whereArgs: [cart.id]
    );
  }

}