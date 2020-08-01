import 'package:flutter/material.dart';
import 'package:ui_practice/screens/landing_page.dart';
import 'package:ui_practice/services/auth.dart';

import 'package:provider/provider.dart';


void main() => runApp(UIApp());

class UIApp extends StatelessWidget {
  const UIApp({Key key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create:(context)=> Auth(),

          child  : MaterialApp(
            title:'practice app',
      
          home: LandingPage()),
    );
  }
}
