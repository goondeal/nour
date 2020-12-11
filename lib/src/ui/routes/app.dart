import 'package:flutter/material.dart';
import 'package:nour/src/services/firestore_service.dart';

import 'package:provider/provider.dart';
import 'package:nour/src/ui/res/colors.dart';
import 'package:nour/src/ui/routes/home.dart';
import 'package:nour/src/ui/routes/auth_home_page.dart';
import 'package:nour/src/models/user.dart';
import 'package:nour/src/models/app_state_model.dart';
import 'package:nour/src/models/user_repository.dart';
import 'package:nour/src/services/auth.dart';

class NourApp extends StatefulWidget {
  @override
  State<NourApp> createState() => _NourAppState();
}


class _NourAppState extends State<NourApp> {
  AppStateModel model;

  @override
  void initState() {
    super.initState();
    model = AppStateModel()..loadProducts();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(
            create: (context) => AuthService(),
          ),
          ChangeNotifierProvider<AppStateModel>(
            create: (context) => model,
          ),
        ],
        child: Consumer<AuthService>(
          builder: (_, AuthService auth, __) =>
              StreamProvider<User>.value(
            initialData: User(
              email: 'email',
              id: 'null',
              joinedSince: 0,
              phoneNumber: 'phone number',
              photoUrl: 'null',
              username: 'username',
            ),
            value: auth.appUser,
            child: MaterialApp(
              title: 'Nour',
              debugShowCheckedModeBanner: false,
              theme: _kNourTheme,
              home: auth.user != null ? Home() : const AuthWrapper(),
            ),
          ),
        ),);

    //   child: MaterialApp(
    //     title: 'Nour',
    //     theme: _kNourTheme,
    //     // routes: <String, WidgetBuilder>{
    //     //  '${OrdersPage.routeName}' : (BuildContext context) => OrdersPage(),
    //     //  },
    //     home: Consumer<AuthService>(
    //       builder: (BuildContext context, AuthService userRepository, _){
    //         return StreamProvider<User>(

    //             //updateShouldNotify: (user, newUser) => user != newUser,
    //             initialData: User(
    //               email: 'email',
    //               id: 'null',
    //               joinedSince: 0,
    //               phoneNumber: 'phone number',
    //               photoUrl: 'null',
    //               username: 'username',
    //             ),
    //             create: (context) => userRepository != null && userRepository.user != null
    //                   ? AuthFirestoreService().getUser(userRepository.user?.uid)
    //                   : null,
    //             child: userRepository.keepedLoggedIn
    //                     ? Home()
    //                     : const AuthWrapper(),

    //       );
    //       }
    //     ),
    //   ),
    // );
  }
}

final ThemeData _kNourTheme = _buildTheme();

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: lgc1);
}

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kNourBlue,
    primaryColor: kNourBackgroundWhite,
    scaffoldBackgroundColor: kNourBackgroundWhite,
    cardColor: kNourBackgroundWhite,
    textSelectionColor: kNourBlueJeans,
    errorColor: kNourRed,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: kNourRed,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: base.iconTheme.copyWith(color: kNourBlack),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5.copyWith(
          fontWeight: FontWeight.w500,
        ),
        headline6: base.headline6.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kNourBlack,
        bodyColor: kNourBlack,
      );
}
