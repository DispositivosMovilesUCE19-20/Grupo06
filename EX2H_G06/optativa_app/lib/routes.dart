import 'package:flutter/material.dart';
import 'con.edu.uce.vista/home_page.dart';
import 'con.edu.uce.vista/login_page.dart';
import 'con.edu.uce.vista/signup_page.dart';
import 'con.edu.uce.vista/signup_student.dart';


final myRoutes = {
  '/': (BuildContext context) => LoginPage(),
  '/signup': (BuildContext context) => SignUpPage(),
  '/signup_est': (BuildContext context) => SignUpStudent(),
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage1(),
};