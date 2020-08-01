import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_practice/screens/home_page.dart';
import 'package:ui_practice/screens/signin_page.dart';
import 'package:ui_practice/services/auth.dart';
import 'package:ui_practice/services/database.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStatechanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) return Signin_page.create(context);
            return Provider<User>.value(value: user,
                          child: Provider<DataBase>(
                create: (context) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
