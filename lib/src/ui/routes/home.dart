import 'package:flutter/material.dart';
import 'package:nour/src/ui/widgets/search_bar.dart';

import 'package:provider/provider.dart';

import 'package:nour/src/ui/routes/expanding_bottom_sheet.dart';
import 'package:nour/src/models/app_state_model.dart';
import 'package:nour/src/models/product.dart';
import 'package:nour/src/models/products_repository.dart';
import 'package:nour/src/ui/widgets/drawer.dart';
import 'package:nour/src/ui/widgets/product_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  AnimationController _controller;
  String _text;
  bool _searchIconClicked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products = ProductsRepository.loadProducts(
        Provider.of<AppStateModel>(context).selectedCategory);

    return Scaffold(
      key: _key,
      drawer: HomeDrawer(),
      drawerEdgeDragWidth: 200.0,
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
        title: _searchIconClicked
            ? SearchBar(
                controller: null,
                onTextChanged: (text) {
                  setState(() {
                    _text = text;
                  });
                },
              )
            : Text('Home', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => _key.currentState.openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _searchIconClicked = !_searchIconClicked;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(16),
            childAspectRatio: 8 / 9,
            children: products
                .where((Product p) => _filterCondition(p.name))
                .map((product) => ProductCard(product: product))
                .toList(),
          ),
          Align(
            child: ExpandingBottomSheet(hideController: _controller),
            alignment: Alignment.bottomRight,
          ),
        ],
      ),
    );
  }

  _filterCondition(String productName) {
    if (_text == null) {
      return true;
    }
    return productName.toLowerCase().contains(_text?.toLowerCase());
  }
}
