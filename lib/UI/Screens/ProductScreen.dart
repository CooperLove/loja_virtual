import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/CartModel.dart';
import 'package:loja_virtual/Model/CartProductModel.dart';
import 'package:loja_virtual/Model/ProductModel.dart';
import 'package:loja_virtual/Model/UserModel.dart';
import 'package:loja_virtual/UI/Screens/CartScreen.dart';
import 'package:loja_virtual/UI/Screens/LoginScreen.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;
  ProductScreen(this.product);
  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductModel product;
  _ProductScreenState(this.product);
  String selectedSize = "";

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url) => NetworkImage(url)).toList(),
              dotColor: primaryColor,
              dotSpacing: 15.0,
              dotSize: 4.0,
              dotBgColor: Colors.transparent,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text("R\$ ${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColor)),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(
                  height: 32,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.5,
                        mainAxisSpacing: 8.0,
                        crossAxisCount: 1),
                    children: product.sizes
                        .map((size) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = size.toString();
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(size),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    border: Border.all(
                                        color: selectedSize == size
                                            ? primaryColor
                                            : Colors.grey[500],
                                        width: 3.0)),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryColor)),
                  onPressed: selectedSize != ""
                      ? () {
                          if (UserModel.of(context).isLoggedIn()) {
                            CartProduct cartProduct = CartProduct();
                            cartProduct.productData = product;
                            cartProduct.size = this.selectedSize;
                            cartProduct.quantity = 1;
                            cartProduct.pid = product.id;
                            cartProduct.category = product.category;

                            Cart.of(context).addProduct(cartProduct);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CartScreen()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          }
                        }
                      : null,
                  child: Text(UserModel.of(context).isLoggedIn()
                      ? "Adicionar ao carrinho"
                      : "Entre para comprar"),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(product.description)
              ],
            ),
          )
        ],
      ),
    );
  }
}
