import 'package:google_sign_in/google_sign_in.dart';
import 'package:nour/src/models/user.dart' as models;
import 'package:nour/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthService with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;


  // Singleton
  AuthService._()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }
  static final _instance = AuthService._();
  factory AuthService() => _instance;

  User get user => _user;
  Status get status => _status;

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    _user = firebaseUser;
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // If new user, save it to the database.
      if (userCredential.additionalUserInfo.isNewUser) {
        FirestoreService().addNewUser(
          user.uid,
          {
            "id": user.uid,
            "username": user.displayName,
            "photoUrl": user.photoURL,
            "email": user.email,
            "phoneNumber": user.phoneNumber,
            "joinedSince": DateTime.now().millisecondsSinceEpoch,
          },
        );
      }

      print('email: ' + user.email);
      print('username: ' + user.displayName ?? 'null');
      print('phone number: ' + user.providerData?.toString() ?? 'null');
      print('photoUrl: ' + user.photoURL ?? 'null');
      print('providedId: ' + user.providerData.toString() ?? 'null');
      print('matadata: ' + user.metadata?.toString() ?? 'null');
      print('isAnonymous: ' + user.isAnonymous?.toString() ?? 'null');

      return true;

    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void signOut() {
    _auth.signOut();
    _googleSignIn.signOut();
  }

  Stream<models.User> get appUser {
    return _user == null
        ? null
        : FirestoreService()
            .getUser(_user.uid)
            .map((doc) => models.User.fromMap(doc.data() ?? {}));
  }
}
