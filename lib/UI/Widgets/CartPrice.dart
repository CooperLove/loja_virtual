import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/CartModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;
  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: ScopedModelDescendant<Cart>(
          builder: (context, child, model) {
            double price = model.getProductsPrice();
            double discount = model.getDiscountPrice();
            double shipping = model.getShippingPrice();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Resumo do pedido"),
                SizedBox(
                  height: 12.0,
                ),
                _pricingRow("Subtotal", price),
                Divider(),
                _pricingRow("Desconto", discount),
                Divider(),
                _pricingRow("Entrega", shipping),
                Divider(),
                SizedBox(
                  height: 12.0,
                ),
                _pricingRow("Total", price - discount + shipping,
                    titleStyle: TextStyle(fontWeight: FontWeight.bold),
                    valueStyle:
                        TextStyle(color: Theme.of(context).primaryColor)),
                SizedBox(
                  height: 12.0,
                ),
                ElevatedButton(
                  onPressed: buy,
                  child: Text("Finalizar Pedido"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor)),
                )
              ],
            );
          },
        ),
      ),
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
}
