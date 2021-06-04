import 'package:flutter/material.dart';
import 'package:loja_virtual/Model/UserModel.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {},
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
              : _signUpForm(context, model);
        },
      ),
    );
  }

  Widget _signUpForm(BuildContext context, UserModel model) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _formField("Nome", TextInputType.name, _nameController, (text) {
            if (text.isEmpty) return "Nome inválido";
            return null;
          }),
          SizedBox(height: 16.0),
          _formField("Email", TextInputType.emailAddress, _emailController,
              (text) {
            if (text.isEmpty || !text.contains("@")) return "Email inválido";
            return null;
          }),
          SizedBox(height: 16.0),
          _formField(
              "Senha", TextInputType.visiblePassword, _passwordController,
              (text) {
            if (text.isEmpty || text.length < 6) return "Senha inválida";
            return null;
          }, obscureText: true),
          SizedBox(height: 16.0),
          _formField("Endereço", TextInputType.text, _addressController,
              (text) {
            if (text.isEmpty) return "Endereço inválido";
            return null;
          }),
          SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                print("Cadastrado meu chapa");
                Map<String, dynamic> userData = {
                  "name": _nameController.text,
                  "email": _emailController.text,
                  "address": _addressController.text,
                };

                model.signUp(
                    userData: userData,
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
            child: Text("Criar Conta"),
          )
        ],
      ),
    );
  }

  Widget _formField(String hintText, TextInputType keyboardType,
      TextEditingController controller, Function(String) validator,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text("Usuário criado com sucesso."),
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Falha ao criar usuário!"),
      duration: Duration(seconds: 2),
    ));
  }
}
