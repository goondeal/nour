import 'package:nour/src/models/order.dart';
import 'package:nour/src/models/user.dart';
import 'package:nour/src/services/firestore_service.dart';
import 'package:nour/src/services/orders_Analyzer.dart';
import 'package:nour/src/ui/res/colors.dart';
import 'package:nour/src/ui/widgets/order_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  static const String routeName = 'ORDERS_PAGE';
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  DateTime from, justBefore; // start and final dates
  User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
    from = DateTime.fromMillisecondsSinceEpoch(user.joinedSince);
    justBefore = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.blue],
            ),
          ),
        ),
        title: Text('ORDERS', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService().getOrdersFor(
            uid: user.id,
            startDate: from.millisecondsSinceEpoch,
            finalDate: justBefore.millisecondsSinceEpoch,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data.docs
                  .map((docSnapshot) => docSnapshot.data())
                  .toList();

              data.sort((a, b) =>
                  (a['orderTime'] as int).compareTo(b['orderTime'] as int) *
                  -1);
               final orders = data.map((doc) => Order.fromMap(doc)).toList();
               final _total = OrdersAnalyzer(orders: orders).totalSpent;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              _buildDateFields('From', from),
                              _buildDateFields('To', justBefore),
                            ],
                          ),
                          Expanded(
                            child: Card(
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'TOTAL',
                                      style: TextStyle(
                                        fontSize: 26.0,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '$_total \$',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children:
                          orders.map((order) => _buildListItem(order)).toList(),
                    ),
                  )
                ],
              );
            }
            return Center(child: Text('No Orders yet'));
          }),
    );
  }

  Widget _buildListItem(Order order) {
    final date = order.orderDateTime;
    final dateString =
        date.toUtc().toString().split(' ')[0].replaceAll('-', '/');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: _stateToColor(order.state),
        child: ExpansionTile(
          leading: _stateToIcon(order.state),
          title: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dateString,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Text('${_fixTime(date.hour)}:${_fixTime(date.minute)}'),
            ],
          ),
          children: <Widget>[OrderLayout(order: order)],
        ),
      ),
    );
  }

  String _fixTime(int time) {
    if (time.toString().length <= 1) {
      return '0$time';
    }
    return time.toString();
  }

  Widget _stateToIcon(OrderState state) {
    switch (state) {
      case OrderState.INIT:
        return Icon(
          Icons.error,
          color: state_init,
        );

      case OrderState.SENT:
        return Icon(
          Icons.done_all,
          color: state_sent,
        );

      case OrderState.SEEN:
        return Icon(
          Icons.done,
          color: state_seen,
        );

      default:
        return Icon(
          Icons.done,
          color: state_delivered,
        );
    }
  }

  Color _stateToColor(OrderState state) {
    switch (state) {
      case OrderState.INIT:
        return secondary_red;

      case OrderState.SENT:
        return secondary_yellow;

      case OrderState.SEEN:
        return secondary_blue;

      default:
        return secondary_green;
    }
  }

  Widget _buildDateFields(String title, DateTime dateTime) {
    // final dt1 = DateTime.fromMillisecondsSinceEpoch(from);
    // final dt2 = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('$title : ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              )),
        ),
        SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () async {
            final choosenDate = await showDatePicker(
              context: context,
              initialDate: from,
              firstDate: DateTime.fromMillisecondsSinceEpoch(user.joinedSince),
              lastDate: DateTime.now(),
            );
            setState(() {
              from = choosenDate ?? from;
            });
          },
          child: Card(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                dateTime.toString().substring(0, 10).replaceAll('-', '/'),
                style: TextStyle(fontSize: 18.0), //, color: Colors.blueAccent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
