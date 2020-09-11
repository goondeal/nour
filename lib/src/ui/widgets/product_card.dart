import 'package:nour/src/models/app_state_model.dart';
import 'package:nour/src/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({this.product, Key key}) : super(key: key);

final Product product;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return InkWell(

onTap: () => Provider.of<AppStateModel>(context).addProductToCart(product.id),
          child: Card(
        clipBehavior: Clip.antiAlias,
        //borderOnForeground: false,
        shape: Border.all(style: BorderStyle.none),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    product.name,
                    style: theme.textTheme.subtitle1,//subtitle1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    formatter.format(product.price),
                    style: theme.textTheme.subtitle2, //subtitle2
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}