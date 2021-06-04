import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  Widget _buildBodyBack() => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 255, 75, 130),
          Color.fromARGB(255, 253, 181, 100)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  print(snapshot.data.docs[0].get("y"));
                }
                return SliverStaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 1.0,
                  staggeredTiles: snapshot.data.docs
                      .map((doc) => StaggeredTile.count(
                          doc["x"], double.tryParse(doc["y"].toString())))
                      .toList(),
                  children: snapshot.data.docs.map((doc) {
                    return FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: doc.get("image"),
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                );
              },
            )
          ],
        )
      ],
    );
  }

  Future<QuerySnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("home")
        .orderBy("priority")
        .get();
  }
}
