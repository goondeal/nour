import 'package:flutter/material.dart';
import 'package:nour/src/services/auth.dart';

import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:nour/src/ui/routes/profile_page.dart';
import 'package:nour/src/models/app_state_model.dart';
import 'package:nour/src/models/product.dart';
import 'package:nour/src/models/user.dart';
import 'package:nour/src/ui/routes/orders_page.dart';
import 'package:nour/src/ui/res/colors.dart';
import 'package:nour/src/ui/widgets/oval_clipper.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OvalClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
            color: primary,
            boxShadow: [BoxShadow(color: Colors.black45)],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [lgc1, lgc3],
            ),
          ),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 32),
                  // Container(
                  //   alignment: Alignment.centerRight,
                  //   child: IconButton(
                  //     icon: Icon(
                  //       Icons.power_settings_new,
                  //       color: active,
                  //     ),
                  //     onPressed: () async {
                  //       await Provider.of<AuthService>(context).signOut();
                  //     },
                  //   ),
                  // ),
                  Consumer<User>(
                    builder: (context, user, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 90,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.pink, Colors.deepPurple],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: CachedNetworkImageProvider(
                              user.photoUrl,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Dr./ ${user.username}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        // Text(
                        //   user.email,
                        //   style: TextStyle(
                        //     color: active,
                        //     fontSize: 16.0,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Theme(
                    data: ThemeData(
                      accentColor: Colors.white,
                    ),
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.all(0.0),
                      selectedColor: Colors.white,
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        leading: Icon(
                          Icons.home,
                          color: active,
                        ),
                        title: Text("Categories".toUpperCase(),
                            style: TextStyle(
                              color: active,
                              fontSize: 16.0,
                            )),
                        children: Category.values
                            .map((Category c) => _buildListItems(c, context))
                            .toList(),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) => _buildMenuItem(
                      Icons.shopping_cart,
                      "My Orders",
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrdersPage(),
                        ),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.person_pin,
                    "My Profile",
                    () {
                      //  final user = Provider.of<User>(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage()));
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(Icons.info, "Info"),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.exit_to_app,
                    'Log Out',
                    () async =>
                        await Provider.of<AuthService>(context).signOut(),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: active,
    );
  }

  Widget _buildListItems(Category category, BuildContext context,
      {double paddingLeft = 16.0}) {
    final String categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();

    return Consumer<AppStateModel>(
        builder: (BuildContext context, AppStateModel model, Widget child) =>
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    model.setCategory(category);
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.white,
                  child: Container(
                    //margin: const EdgeInsets.all(4),
                    //color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Row(children: [
                        SizedBox(width: paddingLeft),
                        Text(
                          categoryString,
                          style: TextStyle(color: active),
                        ),
                      ]),
                    ),
                  ),
                ),
                //_buildDivider()
              ],
            ));
  }

  Widget _buildMenuItem(IconData icon, String title, [Function onTap]) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(children: [
          Icon(
            icon,
            color: active,
          ),
          const SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
        ]),
      ),
    );
  }
}
