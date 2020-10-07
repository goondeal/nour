import 'package:meta/meta.dart';
import 'package:nour/src/models/order.dart';

class OrdersAnalyzer{
  final List<Order> orders;
  
  OrdersAnalyzer({@required this.orders});
  
  List<Map<String, dynamic>> get ordersSummary => 
     orders.map(
      (order) => {
        'date_time': order.orderTime,
        'price': order.orderPrice,
        // 'product_quantity': 

  }).toList();
  
  // Map<int, int> get productQuantity{
  //   final Map<int, int> result = {};
  //   orders.forEach((order) {
  //     order.products.keys.forEach((productID) {
  //       try{
  //         result[productID] += order.products[productID][0];
  //       }catch(e){
  //          result[productID] = order.products[productID][0];
  //       }
  //       result[productID]??= result[productID] + order.products[productID][0]; 
  //      });
  //   });
  //   return result;
  // }

  double get totalSpent => orders
  .map((order) => order.orderPrice)
  .toList()
  .fold(0, (previousValue, price) => previousValue + price);

}