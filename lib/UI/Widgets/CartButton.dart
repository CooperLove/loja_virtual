import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/CartModel.dart';
import 'package:loja_virtual/UI/Screens/CartScreen.dart';

class CartButton extends StatelessWidget {
  // final _pageController;
  // CartButton(this._pageController);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CartScreen()));
      },
    );
  }
}
