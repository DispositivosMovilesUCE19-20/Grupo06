import 'package:app_optativa/com.edu.uce.optativa3.vista/pages/home_page.dart';
import 'package:app_optativa/com.edu.uce.optativa3.vista/pages/login_page.dart';
import 'package:app_optativa/com.edu.uce.optativa3.vista/pages/signup_page.dart';
import 'package:app_optativa/com.edu.uce.optativa3.vista/pages/signup_student.dart';
import 'package:flutter/material.dart';


final myRoutes = {
  '/': (BuildContext context) => LoginPage(),
  '/signup': (BuildContext context) => SignUpPage(),
  '/signup_est': (BuildContext context) => SignUpStudent(),
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage1(),
};