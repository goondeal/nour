import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nour/src/models/order.dart';

const String ORDERS_COLLECTION = 'orders';
const String USERS_COLLECTION = 'doctors';
const String PRODUCTS_COLLECTION = 'products';

class FirestoreService {
  // Singleton.
  FirestoreService._();
  static final _firestoreService = FirestoreService._();

  factory FirestoreService() {
    return _firestoreService;
  }

  /// Firestore instance.
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  /*------------------------- Atomic Functions ------------------------- */

  /// Creates a new document at this [doPath] and 
  /// writes the provided [data] in it.    
  Future<void> _createDocument(String docPath, Map<String, dynamic> data) {
    return _db.doc(docPath).set(data);
  }

  /// Updates the document at this [docPath] with the new [data].
  Future<void> _updateDocument(String docPath, Map<String, dynamic> data) {
    return _db.doc(docPath).update(data);
  }

  /// Get the snapshot of the document at this [docPath].
  Future<DocumentSnapshot> _getDocument(String docPath) {
    return _db.doc(docPath).get();
  }

  /// Get all documents in this [collectionPath].
  Stream<QuerySnapshot> _getAllDocuments(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }

  /// Get the products from firestore.
  Stream<QuerySnapshot> getProducts() {
    return _db.collection(PRODUCTS_COLLECTION).snapshots();
  }

  /// Set the order state or change it.
  Future<void> setOrderStateTo(Order order, String newState) {
    // Update the order with the new state.
    return _updateDocument(order.path, {'state': newState});
  }

  /// Adds a new order in the database.
  Future<void> addOrder(Order order) {
    // Create a new document with the order's info.
    return _createDocument(order.path, order.toMap);
  }

  /// A function that returns the orders for a specific user
  /// the result stream is controlled by a start and final dates to fetch
  ///  the orders in between.
  Stream<QuerySnapshot> getOrdersFor(
      {String uid, int startDate, int finalDate}) {
    final path = '$USERS_COLLECTION/$uid/$ORDERS_COLLECTION';
    return _db
        .collection(path)
        .where('orderTime', isGreaterThanOrEqualTo: startDate)
        .where('orderTime', isLessThan: finalDate)
        .snapshots();
  }

  /// Get user by [id].
  Stream<DocumentSnapshot> getUser(String id) {
    return _db.collection(USERS_COLLECTION).doc(id).snapshots();
  }

  /// Adds a new user in the datbase.
  Future<void> addNewUser(String id, Map<String, dynamic> data) {
    // The user path.
    final path = '$USERS_COLLECTION/$id';
    // Add to the database.
    return _createDocument(path, data);
  }


  // // DocumentReference refFrom(String path, String id) =>
  // //     _db.collection(path).doc(id);

  // /// Check if a document exists.
  // Future<bool> isDocExists(DocumentReference ref) =>
  //     ref.get().then((snapshot) => snapshot.exists);
}
