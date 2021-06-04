import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/CartProductModel.dart';
import 'package:loja_virtual/Model/UserModel.dart';
import 'package:scoped_model/scoped_model.dart';

class Cart extends Model {
  List<CartProduct> products = [];

  bool isLoading = false;
  String _couponCode;
  String get couponCode => _couponCode;
  int _discountPercentage = 0;

  UserModel userModel;
  Cart(this.userModel) {
    if (userModel.isLoggedIn()) _loadCartItems();
  }

  static Cart of(BuildContext context) => ScopedModel.of<Cart>(context);

  void addProduct(CartProduct product) {
    products.add(product);

    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.user.uid)
        .collection("cart")
        .add(product.toMap())
        .then((doc) {
      product.cid = doc.id;
    });

    notifyListeners();
  }

  void removeProduct(CartProduct product) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.user.uid)
        .collection("cart")
        .doc(product.cid)
        .delete();

    products.remove(product);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    _updateProduct(cartProduct);
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    _updateProduct(cartProduct);
  }

  void _updateProduct(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.user.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.user.uid)
        .collection("cart")
        .get();

    products = query.docs.map((doc) {
      return CartProduct.fromDocument(doc);
    }).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this._couponCode = couponCode;
    this._discountPercentage = discountPercentage;
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) price += c.quantity * c.productData.price;
    }

    return price;
  }

  double getDiscountPrice() {
    return getProductsPrice() * this._discountPercentage / 100;
  }

  double getShippingPrice() => 9.99;

  void updatePrices() => notifyListeners();

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    double price = getProductsPrice();
    double discount = getDiscountPrice();
    double shipping = getShippingPrice();

    DocumentReference orderRef =
        await FirebaseFirestore.instance.collection("orders").add({
      "clientId": 0,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "productsPrice": price,
      "discountPrice": discount,
      "shippingPrice": shipping,
      "totalPrice": price - discount + shipping,
      "status": 1
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.user.uid)
        .collection("orders")
        .doc(orderRef.id)
        .set({"orderId": orderRef.id});

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.user.uid)
        .collection("cart")
        .get();

    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear();

    this._couponCode = null;
    this._discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return orderRef.id;
  }
}
