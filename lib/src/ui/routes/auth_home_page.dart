import 'package:nour/src/ui/routes/home.dart';
import 'package:nour/src/ui/routes/login.dart';
import 'package:nour/src/models/user_repository.dart';
import 'package:nour/src/ui/routes/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(
      builder: (BuildContext context, UserRepository user, _){
        switch (user.status) {
          case Status.Uninitialized:
            return LandingPage();
          case Status.Authenticating:
          case Status.Unauthenticated:
            return LoginPage();
          default: // case Status.Authenticated:
            return Home();
        }
      },
    );
  }
}