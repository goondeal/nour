import 'package:meta/meta.dart';

enum OrderState { INIT, SENT, SEEN, DELIVERED }

class ProductDetails {
  final int id;
  final int quantity;
  final double price;

  double get totalPrice => this.quantity * this.price;

  const ProductDetails({this.id, this.quantity, this.price});

  ProductDetails.fromData(MapEntry<String, dynamic> mapEntry)
      : id = int.parse(mapEntry.key),
        quantity = int.parse(mapEntry.value.first),
        price = double.parse(mapEntry.value.last);

  MapEntry<String, dynamic> get toData =>
      MapEntry(id.toString(), [quantity, price]);
}

class Order {
  // ex: [productX.id, quantity, price_when_order_requested]
  // final Map<int, List<num>> products;
  final List<ProductDetails> products;
  final int orderTime; // MillisecondsSinceEpoch
  final String doctor;
  final OrderState state;

  Order({
    @required this.products,
    @required this.orderTime,
    @required this.doctor,
    @required this.state,
  });

  // int get totalQuantity {
  //   int sum = 0;
  //   products.values.forEach((list) {
  //     sum += list.first;
  //   });
  //   return sum;
  // }

  int get totalQuantity =>
      products.fold(0, (sum, productDetails) => sum + productDetails.quantity);

  // double get orderPrice {
  //   final x = products.values.map((val) => val[0] * val[1] * 1.0).toList();
  //   final sum =
  //       x.fold(0.0, (previousValue, element) => previousValue + element);
  //   return sum;
  // }

  double get orderPrice => products.fold(
      0.0, (sum, productDetails) => sum + productDetails.totalPrice);

  Order.fromMap(Map<String, dynamic> data)
      : products = (Map<String, dynamic>.from(data['products']))
            .entries
            .map((e) => ProductDetails.fromData(e)),
        // products = (Map<String, dynamic>.from(data['products'])).map(
        //       (key, value) => MapEntry(int.parse(key), List<num>.from(value))),
        orderTime = data['orderTime'],
        doctor = data['doctor'],
        state = OrderState.values
            .firstWhere((e) => e.toString() == 'OrderState.${data['state']}');
  // state = OrderState.SENT;

  DateTime get orderDateTime => DateTime.fromMillisecondsSinceEpoch(orderTime);

  //String get orderPath => orderDateTime.toUtc().toString().split(' ')[0].replaceAll('-', '/');

  Map<String, dynamic> get toMap => {
      'doctor': doctor,
      'orderTime': orderTime,
      'products': Map<String, dynamic>.fromEntries(products.map((e) => e.toData)),
      'state': state.toString().split('.').last,
    };
  
    // final Map<String, dynamic> tmp = {
    //   'doctor': doctor,
    //   'orderTime': orderTime,
    //   'products': Map<String, dynamic>.fromEntries(products.map((e) => e.toData)),
    //   'state': state.toString().split('.').last,
    // };
    // tmp.addAll({'products': products.map((k, v) => MapEntry(k.toString(), v))});
    // return tmp;
  

  String get orderID => '${doctor}_$orderTime';
}
