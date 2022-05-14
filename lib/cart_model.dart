// ignore_for_file: unnecessary_this

class Cart {
  late final int? id;
  late final String? productId;
  late final String? productName;
  late final int? initialPrice;
  late final int? productPrice;
  late final int? quantity;
  late final String? unitTag;
  late final String? image;

  Cart(
      {
        required this.id,
        required this.productId,
        required this.productName,
        required this.productPrice,
        required this.initialPrice,
        required this.quantity,
        required  this.unitTag,
        required this.image});

  Cart.fromMap(Map<dynamic,dynamic>res){
    this.id=res['id'];
    this.productId=res['productId'];
    this.productName=res['productName'];
    this.productPrice=res['productPrice'];
    this.initialPrice=res['initialPrice'];
    this.quantity=res['quantity'];
    this.unitTag=res['unitTag'];
    this.image=res['image'];
  }
  Map<String,Object?>toMap(){
    return{
      'id':id,
      'productId':productId,
      'productName':productName,
      'productPrice':productPrice,
      'initialPrice':initialPrice,
      'quantity':quantity,
      'unitTag':unitTag,
      'image':image
    };
  }




}
