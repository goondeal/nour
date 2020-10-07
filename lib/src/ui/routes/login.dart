import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nour/src/ui/res/colors.dart';

import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'package:nour/src/models/user_repository.dart';

class LoginPage extends StatelessWidget {
  final TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          Image.asset(
            'assets/nour.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenSize.height * 0.5),
                // Container(
                //   width: screenSize.width * 0.18,
                //   height: screenSize.width * 0.18,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     gradient: LinearGradient(
                //       colors: [lgc1, lgc2],
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,

                //     ),
                //   ),
                //   child: Center(
                //     child: CircleAvatar(
                //       radius: screenSize.width * 0.2 - 4,
                //       backgroundColor: Colors.grey[400],
                //       child: Center(
                //         child: IconButton(
                //           icon: Icon(Icons.add, color: Colors.black,),
                //           onPressed: _pickImage,
                //           ),
                //       ),
                //     ),
                //   ),
                // ),

                Text(
                  'Continue with : ',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: kNourBlue,
                  ),
                ),
                const SizedBox(height: 28),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                        radius: screenSize.width * 0.08,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (!await user.signInWithGoogle()) {
                            //   showBottomSheet(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //     return Container(
                            //       height: 200,
                            //       color: Colors.amber,
                            //       child: Center(
                            //         child: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: <Widget>[
                            //              Text(user.error),
                            //             RaisedButton(
                            //               child:
                            //                   const Text('OK'),
                            //               onPressed: () =>
                            //                   Navigator.pop(context),
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   });

                            Toast.show(
                                'No Internet Connection',
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM,
                              );
                             }

                              
                          },
                        ),
                        ),
                    SizedBox(width: 32),
                    CircleAvatar(
                      radius: screenSize.width * 0.08,
                      backgroundColor: Colors.black,
                      child: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.apple,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0 * 3),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       RaisedButton(
                //         onPressed: () async {
                //           if (!await user.signInWithGoogle()) {
                //             Toast.show(
                //               'something went wrong, try again later',
                //               context,
                //               duration: Toast.LENGTH_LONG,
                //               gravity: Toast.BOTTOM,
                //             );
                //           }
                //         },
                //         shape: BeveledRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //           // side: BorderSide(style: BorderStyle.solid, color: Colors.red),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0 * 2),
                //           child: Row(
                //             children: <Widget>[
                //               Text(
                //                 'G+',
                //                 style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 22.0,
                //                 ),
                //               ),
                //               SizedBox(width: 16.0),
                //               Expanded(
                //                 child: Center(
                //                   child: Text(
                //                     'Sign in with Google+',
                //                     style: TextStyle(color: Colors.white),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         color: Colors.red,
                //         elevation: 4.0,
                //       ),
                //       SizedBox(height: 32),
                // FlatButton(
                //   onPressed: () {},
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0 * 2),
                //     child: Text(
                //       'Sign up with Google+',
                //       style: TextStyle(color: Colors.red),
                //     ),
                //   ),
                //   shape: BeveledRectangleBorder(
                //     borderRadius: BorderRadius.circular(8),
                //     side: BorderSide(
                //         style: BorderStyle.solid, color: Colors.red),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    )
        //],
        //),
        //),
        );
  }

  void _pickImage() {}
}

// class AccentColorOverride extends StatelessWidget {
//   const AccentColorOverride({Key key, this.color, this.child})
//       : super(key: key);

//   final Color color;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       child: child,
//       data: Theme.of(context).copyWith(
//         accentColor: color,
//         brightness: Brightness.dark,
//       ),
//     );
//   }
// }
