import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String category;
  String id;
  String title;
  String description;
  double price;
  List sizes;
  List images;

  ProductModel.fromMap(Map mapModel) {
    title = mapModel["title"];
    description = mapModel["description"];
    price = mapModel["price"];
  }

  ProductModel.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    // category = ;
    title = snapshot["title"];
    description = snapshot["description"];
    price = snapshot["price"] + 0.0;
    sizes = snapshot["sizes"];
    images = snapshot["images"];
  }

  Map<String, dynamic> resumedMap() {
    return {"title": title, "description": description, "price": price};
  }
}
