import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile(this.document, {Key key}) : super(key: key);

  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(document["image"]),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document["name"],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  Text(
                    document["address"],
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    launch(
                        "https://www.google.com/maps/search/?api=1&query=${document["latitude"]},${document["longitude"]}");
                  },
                  child: Text("Ver no mapa"),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    launch("tel:${document["phone"]}");
                  },
                  child: Text("Ligar"),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
