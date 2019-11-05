import 'package:flutter/material.dart';
import 'package:app_optativa/data/database_helper.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Registro'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (input) {
                if (input.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
              },
            ),
            TextFormField(
              controller: lastnameController,
              decoration: InputDecoration(labelText: 'Apellido'),
              validator: (input) {
                if (input.isEmpty) {
                  return 'Por favor ingresa tu apellido';
                }
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (input) {
                if (input.isEmpty) {
                  return 'Por favor ingresa tu Email';
                }
              },
            ),
            TextFormField(
              controller: celularController,
              decoration: InputDecoration(labelText: 'Celular'),
              keyboardType: TextInputType.number,
              validator: (input) {
                if (input.isEmpty) {
                  return 'Por favor ingresa tu numero celular';
                }
              },
            ),
            TextFormField(
              controller: usuarioController,
              decoration: InputDecoration(labelText: 'Usuario'),
              validator: (input) {
                if (input.isEmpty) {
                  return 'Por favor ingresa tu Usuario';
                }
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (input) {
                if (input.isEmpty) {
                  return 'Por favor ingresa password';
                }
              },
            ),
            RaisedButton(
              child: Text('Registrar'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  DBHelper dbHelper = DBHelper();
                  dbHelper.saveUser(
                    nameController.text,
                    lastnameController.text,
                    emailController.text,
                    celularController.text,
                    usuarioController.text,
                    passwordController.text,
                  );

                  dbHelper.listUser();
                  
                  Navigator.pushReplacementNamed(context, '/login');
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
