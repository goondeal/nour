import 'package:nour/src/models/user.dart';
import 'package:nour/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirestoreService {
  AuthFirestoreService._();

  static final AuthFirestoreService _authFirestoreService =
      AuthFirestoreService._();

  factory AuthFirestoreService() => _authFirestoreService;

  void saveUser(FirebaseUser user) async {
    final docRef = FirestoreService().refFrom(USERS_COLLECTION, user.uid);
    final doctorExists = await FirestoreService().isDocExists(docRef);

    if (!doctorExists) {
      print('user does not exist');
      await FirestoreService().addDocument(
          USERS_COLLECTION, // collection path
          user.uid, // documentID
          // data (Map<String, dynamic>)
          {
            "id": user.uid,
            "username": user.displayName,
            "photoUrl": user.photoUrl,
            "email": user.email,
            "phoneNumber": user.phoneNumber,
            "joinedSince": DateTime.now().millisecondsSinceEpoch,
          });
    }
    print('user exists');
  }

  Stream<User> getUser(String uid) {
    return uid == null 
    ? null 
    : FirestoreService()
        .getDocumentSnapshot(USERS_COLLECTION, uid)
        .map((doc) => User.fromMap(doc.data ?? {}));
  }
}
