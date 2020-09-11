import 'package:nour/src/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;
  bool keepedLoggedIn = false;
  String error = '';

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
    _checkIfKeepedLoggedIn();
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  void setStatus(Status newStatus) {
    _status = newStatus;
    // notifyListeners();
  }

  void _setLoggedInTo(bool val) {
    SharedPreferences.getInstance().then(
      (SharedPreferences prefs) => prefs.setBool('keep_login', val),
    );
    keepedLoggedIn = val;
    //notifyListeners();
  }

  void _checkIfKeepedLoggedIn() {
    SharedPreferences.getInstance().then(
      (SharedPreferences prefs) =>
          keepedLoggedIn = prefs.getBool('keep_login') ?? false,
    );
  }

  void _keepLoggedIn() => _setLoggedInTo(true);
  void _cancelKeepLoggedIn() => _setLoggedInTo(false);


  void notifyAfter(List<List<dynamic>> functionsWithParameters) {
    functionsWithParameters.forEach((functionWithParameter) {
      // For void Functions
      if (functionWithParameter.length == 1) {
        Function.apply(functionWithParameter[0], null);
      } else {
        // For Functions with parameters
        Function.apply(functionWithParameter[0], functionWithParameter[1]);
      }
    });
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
    notifyAfter([
      [setStatus, [Status.Authenticating] ]
    ]);
    //setStatus(Status.Authenticating);

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    return user;
  }

  Future<bool> signInWithGoogle() async {
    try {
      final FirebaseUser user = await _handleSignIn();

      print('email: ' + user.email);
      print('username: ' + user.displayName ?? 'null');
      print('phone number: ' + user.providerData?.toString() ?? 'null');
      print('photoUrl: ' + user.photoUrl ?? 'null');
      print('providedId: ' + user.providerId ?? 'null');
      print('matadata: ' + user.metadata?.toString() ?? 'null');
      print('isAnonymous: ' + user.isAnonymous?.toString() ?? 'null');

      AuthFirestoreService().saveUser(user);
      notifyAfter([
        [_keepLoggedIn],
        [setStatus, [Status.Authenticated] ]
      ]);
      // _keepLoggedIn();
      // setStatus(Status.Authenticated);
      return true;
    } catch (e) {
      print(e);
      error = e.message;
      notifyAfter([
        [setStatus, [Status.Unauthenticated] ],
        [_cancelKeepLoggedIn],
      ]);
      // setStatus(Status.Unauthenticated);
      // _cancelKeepLoggedIn();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    setStatus(Status.Unauthenticated);
    _cancelKeepLoggedIn();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    _user = firebaseUser;
    _status =
        firebaseUser == null ? Status.Unauthenticated : Status.Authenticating;
    notifyListeners();
  }

  // Future<bool> signIn(String email, String password) async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     return true;
  //   } catch (e) {
  //     _status = Status.Unauthenticated;
  //     error = e.message;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<bool> signUp(String fullName, String email, String password) async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();

  //     FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
  //             email: email, password: password))
  //         .user;
  //     UserUpdateInfo info = UserUpdateInfo();
  //     info.displayName = fullName;
  //     await user.updateProfile(info);
  //     await AuthFirestoreService().saveUser(user);
  //     return true;
  //   } catch (e) {
  //     _status = Status.Unauthenticated;
  //     error = e.message;
  //     notifyListeners();
  //     return false;
  //   }
  // }

}
