import 'package:flutter/material.dart';
import 'package:app_optativa/pages/home_page.dart';
import 'package:app_optativa/pages/login_page.dart';
import 'package:app_optativa/pages/signup_page.dart';

final myRoutes = {
  '/': (BuildContext context) => LoginPage(),
  '/signup': (BuildContext context) => SignUpPage(),
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
};