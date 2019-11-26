import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageTest extends StatefulWidget {
  @override
  _PageTest createState() => _PageTest();
}

class _PageTest extends State<PageTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diseño"),
      ),
      body: Center(
        
          child: Column(
            children: <Widget>[
              Icon(Icons.supervised_user_circle,size: 150,),
              Text("Nombre", style:  TextStyle(fontSize: 30.0, color: Colors.black38),),
              Text("Apellido", style:  TextStyle(fontSize: 30.0, color: Colors.black38),)
            ],
          ),
        ),
     
    );
  }
}
