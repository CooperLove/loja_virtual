import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/ProductModel.dart';

import '../Tiles/ProductTile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;
  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    // print("${snapshot["items"]}");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("products")
              .doc(snapshot.id)
              .collection("items")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        print("Produto ${snapshot.data.docs[index]}");
                        ProductModel product = ProductModel.fromDocument(
                            snapshot.data.docs[index]);
                        product.category = this.snapshot.id;
                        return ProductTile("grid", product);
                      }),
                  ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        print("Produto ${snapshot.data.docs[index]}");
                        ProductModel product = ProductModel.fromDocument(
                            snapshot.data.docs[index]);
                        product.category = this.snapshot.id;
                        return ProductTile("list", product);
                      }),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
