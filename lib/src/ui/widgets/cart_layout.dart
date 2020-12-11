import 'package:nour/src/ui/res/colors.dart';
import 'package:nour/src/ui/routes/expanding_bottom_sheet.dart';
import 'package:nour/src/models/app_state_model.dart';
import 'package:nour/src/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const double _leftColumnWidth = 60.0;

class CartLayout extends StatelessWidget {
  final AppStateModel model;

  CartLayout({this.model, Key key}) : super(key: key);

  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (k) => ShoppingCartRow(
            product: model.getProductById(k),
            quantity: model.productsInCart[k],
            onPressed: () => model.removeItemFromCart(k),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);
    final model = Provider.of<AppStateModel>(context);
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: _leftColumnWidth,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                onPressed: () => ExpandingBottomSheet.of(context).close(),
              ),
            ),
            Text(
              'CART',
              style: localTheme.textTheme.subtitle1
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 16.0),
            Text('${model.totalCartQuantity} ITEMS'),
          ],
        ),
        const SizedBox(height: 16.0),
        Column(
          children: _createShoppingCartRows(model),
        ),
        ShoppingCartSummary(model: model),
        const SizedBox(height: 100.0),
      ],
    );
  }
}

class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({this.model});

  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final TextStyle largeAmountStyle = Theme.of(context).textTheme.headline4;
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );

    return Row(
      children: <Widget>[
        const SizedBox(width: _leftColumnWidth),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      child: Text('TOTAL'),
                    ),
                    Text(
                      formatter.format(model.subtotalCost),
                      style: largeAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShoppingCartRow extends StatelessWidget {
  const ShoppingCartRow({
    @required this.product,
    @required this.quantity,
    this.onPressed,
  });

  final Product product;
  final int quantity;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    final ThemeData localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        key: ValueKey<int>(product.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: _leftColumnWidth,
            child: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onPressed,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        product.assetName,
                        package: product.assetPackage,
                        fit: BoxFit.cover,
                        width: 75.0,
                        height: 75.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text('Quantity: $quantity'),
                                ),
                                Text('x ${formatter.format(product.price)}'),
                              ],
                            ),
                            Text(
                              product.name,
                              style: localTheme.textTheme.subtitle1
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    color: kShrineBrown900,
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
