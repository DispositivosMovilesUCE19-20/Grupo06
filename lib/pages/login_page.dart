import 'package:flutter/material.dart';
import 'package:app_optativa/model/user_model.dart';
import 'package:app_optativa/data/database_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Image.asset(
          "assets/images/logo.png",
          height: 40.0,
        ),
        actions: <Widget>[
          Text("Registrate->",style: TextStyle(fontSize: 20.0)),
          InkWell(
            child: Image.asset(
              "assets/images/registrar.png",
              height: 40.0,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
        ],
      ),
      body:  Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: usuarioController,
              decoration: InputDecoration(labelText: 'Usuario'),              
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor ingresa tu usuario';
                }
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor ingresa tu password';
                }
              },
            ),
            RaisedButton(
              child: Text(
                'Ingresa',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _authenticateUser,
            ),
          ],
        ),
      ),
    );
  }

  _authenticateUser() async {
    if (_formKey.currentState.validate()) {
      DBHelper dbHelper = DBHelper();
      dbHelper
          .getUser(usuarioController.text, passwordController.text)
          .then((List<User> users) {
        if (users != null && users.length > 0) {
          Navigator.pushNamed(context, '/home');
          print('[LoginPage] _authenticateUser: Success');
        } else {
          print('[LoginPage] _authenticateUser: Invalid credentials');
        }
      });
    }
  }
}
