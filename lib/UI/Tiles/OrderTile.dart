import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/CartProductModel.dart';

class OrderTile extends StatelessWidget {
  final String orderId;
  OrderTile(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: 365,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .doc(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double price = snapshot.data["productsPrice"];
              double discount = snapshot.data["discountPrice"];
              double shipping = snapshot.data["shippingPrice"];

              int status = snapshot.data["status"];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Pedido $orderId",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text("Descrição: "),
                  Divider(),
                  for (Map cartProduct in snapshot.data["products"])
                    _productDescription(CartProduct.fromMap(cartProduct)),
                  _pricingRow("Subtotal", price),
                  _pricingRow("Desconto", discount),
                  _pricingRow("Frete", shipping),
                  Divider(),
                  _pricingRow("Total", price - discount + shipping,
                      titleStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                      valueStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  Divider(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Status do pedido",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircle("1", "Preparação", status, 1),
                      _buildLine(),
                      _buildCircle("2", "Enviado", status, 2),
                      _buildLine(),
                      _buildCircle("3", "Entregue", status, 3),
                    ],
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _productDescription(CartProduct cartProduct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${cartProduct.quantity}x - ${cartProduct.productData.title}"),
            Text(
                "Preço: R\$ ${(cartProduct.productData.price * cartProduct.quantity).toStringAsFixed(2)}")
          ],
        ),
        Text("Tamanho ${cartProduct.size}"),
        Divider(),
      ],
    );
  }

  Widget _pricingRow(String title, double value,
      {TextStyle titleStyle = const TextStyle(),
      TextStyle valueStyle = const TextStyle()}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        Text(
          "R\$ ${value.toStringAsFixed(2)}",
          style: valueStyle,
        )
      ],
    );
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backgroundColor;
    Widget child;

    if (status < thisStatus) {
      backgroundColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backgroundColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
        ],
      );
    } else {
      backgroundColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backgroundColor,
          child: child,
        ),
        Text(
          subtitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      height: 1.0,
      width: 40.0,
      color: Colors.grey,
    );
  }
}
