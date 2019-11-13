

import 'package:app_optativa/data/preferences_shared.dart';
import 'package:flutter/material.dart';
import 'package:app_optativa/model/user_model.dart';
import 'package:app_optativa/data/database_helper.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  

  

  String temp = "";
  String userKey = "_key_user";
  String passwordKey = "_key_password";

  @override
  void initState() {
    super.initState();

  }

  setDataUser() {
    Preference.instance.loadDataUser().then((value) {
      setState(() {
        temp = value;
        
      });
    });
  }
  

  setDataPassword() {
    Preference.instance.loadDataPassword().then((value) {
      setState(() {
        temp = value;
        
      });
    });
  }



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
          Text("Registrate->",
              style: TextStyle(fontSize: 20.0), textAlign: TextAlign.left),
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
      body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  
                  TextFormField(
                    controller: usuarioController,
                    decoration: InputDecoration(labelText: 'Usuario'),
                    onChanged: (value) {
                      
                    },
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
                    onChanged: (value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingresa tu password';
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Ingresar',
                      style: TextStyle(fontSize: 20),
                    ),
                    padding: EdgeInsets.all(4.0),
                    onPressed: _authenticateUser,
                    

                  ),
                  Text(
                    temp,
                    style: TextStyle(fontSize: 20),
                  ),
                  OutlineButton(
                    child: Text("Ultimo usuario que ingreso"),
                    onPressed: () {
                      setDataUser();
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  _authenticateUser() async {
    if (_formKey.currentState.validate()) {
      DBHelper dbHelper = DBHelper();
      dbHelper
          .getUser(usuarioController.text, passwordController.text)
          .then((List<User> users) {
        if (users != null && users.length > 0) {          
          Preference.instance.saveDataUser(usuarioController.text);
          Preference.instance.saveDataPassword(passwordController.text);
          Navigator.pushNamed(context, '/home');
          print('[LoginPage] _authenticateUser: Success');
        } else {
          print('[LoginPage] _authenticateUser: Invalid credentials');
        }
      });
    }
  }
}
