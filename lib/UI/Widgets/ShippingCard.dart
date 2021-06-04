import 'package:flutter/material.dart';

class ShippingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cálcular frete",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.location_on),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: "",
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu CEP"),
              onFieldSubmitted: (text) {},
            ),
          )
        ],
      ),
    );
  }
}