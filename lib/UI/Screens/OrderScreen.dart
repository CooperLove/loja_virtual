import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final _orderId;
  OrderScreen(this._orderId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido finalizado"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              "Pedido realizado com sucesso!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Id do pedido: $_orderId")
          ],
        ),
      ),
    );
  }
}
