import 'package:flutter/material.dart';
import 'routes.dart';

void main() => runApp(MyApp01());

class MyApp01 extends StatelessWidget {
  final String _appName = 'Proyecto';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appName,
      debugShowCheckedModeBanner: false,
      routes: myRoutes,
      
    );
  }
}


