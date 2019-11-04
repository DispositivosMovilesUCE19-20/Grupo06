import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter app',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
      ),
      home: OptaHome(),
    );
  }
}

class OptaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown,
        appBar: AppBar(
          title: Image.asset(
            "assets/images/logo.png",
            height: 40.0,
          ),
          actions: <Widget>[
            InkWell(
              child: Image.asset(
                "assets/images/registrar.png",
                height: 40.0,
              ),
              onTap: () {},
            )
          ],
        ),
        body: Center(
          child: Container(
             height: 100.0,
              decoration: BoxDecoration(
                border: Border.all()),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 70.0),
              )),
        ));
  }
}
