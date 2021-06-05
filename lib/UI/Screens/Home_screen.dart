import 'package:flutter/material.dart';
import 'package:loja_virtual/UI/Screens/CartScreen.dart';
import 'package:loja_virtual/UI/Tabs/OrdersTab.dart';
import 'package:loja_virtual/UI/Widgets/CartButton.dart';
import '../Tabs/HomeTab.dart';
import '../Tabs/ProductsTab.dart';
import '../Widgets/CustomDrawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
          body: ProductsTab(),
        ),
        Container(
          color: Colors.amberAccent,
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          // floatingActionButton: CartButton(),
          body: OrdersTab(),
        ),
      ],
    );
  }
}
