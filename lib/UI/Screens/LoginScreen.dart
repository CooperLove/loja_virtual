import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/UserModel.dart';
import 'package:loja_virtual/UI/Screens/SignUpScreen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text(
                "CRIAR UMA CONTA",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ))
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return model.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _loginForm(context, model);
        },
      ),
    );
  }

  Widget _loginForm(BuildContext context, UserModel model) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(hintText: "Email"),
            keyboardType: TextInputType.emailAddress,
            validator: (text) {
              if (text.isEmpty || !text.contains("@")) return "Email inválido";
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: "Senha"),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: (text) {
              if (text.isEmpty || text.length < 6) return "Senha inválida";
              return null;
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (_emailController.text.isEmpty) {
                  _showSnackbar("Insira seu email para recuperação!",
                      color: Colors.redAccent);
                } else {
                  model.recoverPassword(_emailController.text);
                  _showSnackbar("Verifique seu email!");
                }
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: Text(
                "Esqueci minha senha",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                print("Entra meu chapa");
                model.signIn(
                    email: _emailController.text,
                    password: _passwordController.text,
                    onSuccess: _onSuccess,
                    onFail: _onFail);
              } else {
                print("Oq q houve?");
              }
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor)),
            child: Text("ENTRAR"),
          )
        ],
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _showSnackbar("Falha efetuar login!", color: Colors.redAccent);
  }

  void _showSnackbar(String text, {Color color}) {
    color = color ?? Theme.of(context).primaryColor;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(text),
      duration: Duration(seconds: 2),
    ));
  }
}
