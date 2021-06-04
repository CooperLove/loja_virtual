import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/CartModel.dart';
import 'package:loja_virtual/Model/CartProductModel.dart';
import 'package:loja_virtual/Model/ProductModel.dart';

class CartTile extends StatelessWidget {
  CartProduct product;
  CartTile(this.product);

  Widget _buildContent(BuildContext context) {
    Cart.of(context).updatePrices();
    return Row(
      children: [
        Container(
          width: 120,
          padding: EdgeInsets.all(8.0),
          child: Image.network(product.productData.images[0]),
        ),
        Expanded(
            child: Container(
          child: Column(
            children: [
              Text(product.productData.title,
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Text("Tamanho ${product.size}"),
              Text(
                "R\$ ${product.productData.price}",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: product.quantity > 1
                        ? () {
                            Cart.of(context).decProduct(product);
                          }
                        : null,
                  ),
                  Text(product.quantity.toString()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Cart.of(context).incProduct(product);
                    },
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Cart.of(context).removeProduct(product);
                  },
                  child: Text(
                    "Remover",
                    style: TextStyle(color: Colors.grey[500]),
                  ))
            ],
          ),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(product.category)
                  .collection("items")
                  .doc(product.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  product.productData =
                      ProductModel.fromDocument(snapshot.data);
                  return _buildContent(context);
                }

                return Container(
                  height: 70.0,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              })
          : _buildContent(context),
    );
  }
}
