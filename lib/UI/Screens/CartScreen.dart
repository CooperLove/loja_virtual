import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/CartModel.dart';
import 'package:loja_virtual/Model/UserModel.dart';
import 'package:loja_virtual/UI/Screens/LoginScreen.dart';
import 'package:loja_virtual/UI/Tiles/CartTile.dart';
import 'package:loja_virtual/UI/Widgets/CustomDrawer.dart';
import 'package:loja_virtual/UI/Widgets/DiscountCard.dart';
import 'package:loja_virtual/UI/Widgets/ShippingCard.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatefulWidget {
  // final _pageController;
  // CartScreen(this._pageController);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // final _pageController;
  // _CartScreenState(this._pageController);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<Cart>(
              builder: (context, child, model) {
                int p = model.products.length;
                return Text("${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}");
              },
            ),
          )
        ],
      ),
      // drawer: CustomDrawer(_pageController),
      body: ScopedModelDescendant<Cart>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text("Faça o login para adicionar produtos!"),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Text("Entrar"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            );
          } else if (model.products == null || model.products.length == 0) {
            return Container(
              child: Center(
                child: Text(
                  "Nenhum produto no carrinho!",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            return ListView(
              children: [
                Column(
                    children: model.products.map((e) {
                  return CartTile(e);
                }).toList()),
                DiscountCard(),
                ShippingCard()
              ],
            );
          }
        },
      ),
    );
  }
}
