import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/Model/ProductModel.dart';

class CartProduct {
  String cid;
  String category;
  String pid;
  int quantity;
  String size;
  ProductModel productData;

  CartProduct();

  CartProduct.fromMap(Map productMap) {
    // cid = productMap.id;
    category = productMap["category"];
    pid = productMap["pid"];
    quantity = productMap["quantity"];
    size = productMap["size"];
    productData = ProductModel.fromMap(productMap["product"]);
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;
    category = document["category"];
    pid = document["pid"];
    quantity = document["quantity"];
    size = document["size"];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productData.resumedMap(),
    };
  }
}
