import 'dart:io';
import 'package:app_optativa/data/database_helper.dart';
import 'package:app_optativa/data/mensaje_provider.dart';
import 'package:app_optativa/data/preferences_shared.dart';
import 'package:app_optativa/model/msg_model.dart';
import 'package:app_optativa/model/user_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  Future<List<User>> user = DBHelper.internal().listUser();
  final mensajeProvider = new MensajeProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Usuarios Registrados'),
        actions: <Widget>[
          FutureBuilder(
            future: mensajeProvider.getData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Mensaje>> snapshot) {
              if (!snapshot.hasData) return Container();
              List<Mensaje> mensaje = snapshot.data;
              return Expanded(
                child: SizedBox(
                  height: 100.0,
                  child: ListView.builder(  
                shrinkWrap: true,             
                itemCount: mensaje.length,
                itemBuilder: (BuildContext context, int index) {
                  Mensaje men = mensaje[index];
                  return _buildMensaje(men);
                },
              ),

                ),
              );
            },
          ),          
        ],
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
                Preference.instance.removeDataUser();
                Preference.instance.removeDataPassword();
                Navigator.pushReplacementNamed(context, '/login');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Salir',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                exit(0);
              },
            )
          ],
        ),
      ),
      body: new FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {}
          if (snapshot.hasError) {}
          List<User> users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User usera = users[index];
              return _buildItem(usera);
            },
          );
        },
      ),
    );
  }
}

Widget _buildItem(User user) {
  return new ListTile(
    title: new Text(user.user),
    subtitle: new Text('Email: ${user.email}'),
    leading: new Icon(Icons.people),
    onTap: () {
      print(user.name);
    },
  );
}

Widget _buildMensaje(Mensaje mensaje) {
  return new Text('${mensaje.msg}',textDirection: TextDirection.rtl,);
}
