import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Model/CartModel.dart';
import 'Model/UserModel.dart';
import 'UI/Screens/Home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return ScopedModel<Cart>(
              model: Cart(model),
              child: MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primaryColor: Color.fromARGB(255, 4, 125, 141),
                  primarySwatch: Colors.blue,
                ),
                debugShowCheckedModeBanner: false,
                home: HomeScreen(),
              ),
            );
          },
        ));
  }
}
