import 'package:meta/meta.dart';

enum OrderState { INIT, SENT, SEEN, DELIVERED }

class Order {
  // ex: [productX.id, quantity, price_when_order_requested]
  final Map<int, List<num>> products;
  final int orderTime; // MillisecondsSinceEpoch
  final String doctor;
  final OrderState state;

  Order({
    @required this.products,
    @required this.orderTime,
    @required this.doctor,
    @required this.state,
  });

  int get totalQuantity {
    int sum = 0;
    products.values.forEach((list) {
      sum += list.first;
    });
    return sum;
  }

  double get orderPrice {
    final x = products.values.map((val) => val[0] * val[1] * 1.0).toList();
    final sum =
        x.fold(0.0, (previousValue, element) => previousValue + element);
    return sum;
  }

  Order.fromMap(Map<String, dynamic> data)
      : products = (Map<String, dynamic>.from(data['products'])).map(
            (key, value) => MapEntry(int.parse(key), List<num>.from(value))),
        orderTime = data['orderTime'],
        doctor = data['doctor'],
        state = OrderState.values
            .firstWhere((e) => e.toString() == 'OrderState.${data['state']}');
  // state = OrderState.SENT;

  DateTime get orderDateTime => DateTime.fromMillisecondsSinceEpoch(orderTime);

  //String get orderPath => orderDateTime.toUtc().toString().split(' ')[0].replaceAll('-', '/');

  Map<String, dynamic> get toMap {
    final Map<String, dynamic> tmp = {
      'doctor': doctor,
      'orderTime': orderTime,
      'state': state.toString().split('.').last,
    };
    tmp.addAll({'products': products.map((k, v) => MapEntry(k.toString(), v))});
    return tmp;
  }

  String get orderID => '${doctor}_$orderTime';
}
