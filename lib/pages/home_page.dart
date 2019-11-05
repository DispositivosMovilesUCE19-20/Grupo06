

import 'package:app_optativa/model/user_model.dart';
import 'package:app_optativa/data/database_helper.dart';
import 'package:flutter/material.dart';

Future<List<User>> getAllUser() async {
return DBHelper.internal().listUser();
}

class HomePage extends StatelessWidget {
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Inicio del Sistema'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              child: DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      size: 70.0,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Cerrar Sesion',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body:  Container(
        child: Center(
          child: Text('revision'),
        ),
        
        )
      );
  }
}
