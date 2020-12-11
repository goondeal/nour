import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nour/src/models/order.dart';

const String ORDERS_COLLECTION = 'orders';
const String USERS_COLLECTION = 'doctors';
const String PRODUCTS_COLLECTION = 'products';

class FirestoreService {
  FirestoreService._();
  static final _firestoreService = FirestoreService._();

  factory FirestoreService() {
    return _firestoreService;
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get the products from firestore.
  Stream<QuerySnapshot> getProducts() {
    return _db.collection(PRODUCTS_COLLECTION).snapshots();
  }

  /// Set the order state or change it.
  void setOrderStateTo(Order order, OrderState newState) {
    updateDocument(
      '$USERS_COLLECTION/${order.doctor}/$ORDERS_COLLECTION',
      order.orderID,
      {'state': newState.toString().split('.').last},
    ).then((value) => print('order state set to $newState'));
  }

  /// Write order to the database.
  Future<void> addOrder(Order order) {
    final path =
        '$USERS_COLLECTION/${order.doctor}/$ORDERS_COLLECTION/${order.orderID}';
    return _db.doc(path).set(order.toMap);
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

  /// Read a document from the database.
  Stream<DocumentSnapshot> getDocumentSnapshot(String path, String id) {
    return _db.collection(path).doc(id).snapshots();
  }

  /// Add new document to the datbase.
  Future<void> addDocument(String path, String id, Map<String, dynamic> data) {
    return _db.collection(path).doc(id).set(data);
  }

  /// Update a document in the database.
  Future<void> updateDocument(String path, String id, Map<String, dynamic> data,
      {bool merge = true}) {
    return _db.collection(path).doc(id).set(data);
  }

  // Future<void> updateDocumentFieldValue(
  //     String path, String id, String field, List<String> elements) {
  //   final docRef = _db.collection(path).doc(id);

  //   return docRef.updateData({field: FieldValue.arrayUnion(elements)});
  // }

  DocumentReference refFrom(String path, String id) =>
      _db.collection(path).doc(id);

  /// Check if a document exists.
  Future<bool> isDocExists(DocumentReference ref) =>
      ref.get().then((snapshot) => snapshot.exists);
}
