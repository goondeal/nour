import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:nour/src/services/orders_Analyzer.dart';


class StatisticsPage extends StatelessWidget {
  final OrdersAnalyzer analyzer;
  const StatisticsPage({@required this.analyzer, Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(

              child: Column(
              children: <Widget>[
        // ExpansionTile(
        //     initiallyExpanded: true,
        //     title: Padding(
        // padding: const EdgeInsets.all(8),
        //       child: Text('All Orders'),
        //       ) ,
        //     children: <Widget>[
              Container(
width: 360,
height: 360,
                  child: charts.TimeSeriesChart(
          _createSampleData(),
          animate: true,
          // behaviors: [
          //   charts.RangeAnnotation([

          //   ])
          // ],
        ),
              )

            ],
          ),
      )
            // ],
          //),
    );
  }


  /// Create one series with sample hard coded data.
   List<charts.Series<Map<String, dynamic>, DateTime>> _createSampleData() {
    final data = analyzer.ordersSummary;
    return [
      charts.Series<Map<String, dynamic>, DateTime>(
        id: 'Sales',
        domainFn: (orderSummary , _) => DateTime.fromMillisecondsSinceEpoch(orderSummary['date_time']),
        measureFn: (orderSummary, _) => orderSummary['price'],
        data: data,
      )
    ];
  }
}
