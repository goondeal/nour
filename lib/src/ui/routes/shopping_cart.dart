// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import 'package:nour/src/ui/res/colors.dart';
import 'package:nour/src/ui/routes/expanding_bottom_sheet.dart';
import 'package:nour/src/models/app_state_model.dart';
import 'package:nour/src/models/order.dart';
import 'package:nour/src/models/user.dart';
import 'package:nour/src/services/firestore_service.dart';
import 'package:nour/src/ui/widgets/cart_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';



class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}


class _ShoppingCartPageState extends State<ShoppingCartPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNourBackgroundWhite,
      body: SafeArea(
        child: Container(
          child: Consumer<AppStateModel>(
            builder: (BuildContext context, AppStateModel model,  Widget child) {
              return Stack(
                children: <Widget>[
                 CartLayout(model: model),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Column(
                      children: <Widget>[
                        _prettyButton(model, 'SEND ORDER', (_){
                          _sendOrder(model).then(
                            (value) => print('order sent'),
                            onError: (e){
                              print(e); 
                            }
                            );
                          model.clearCart();
                          ExpandingBottomSheet.of(context).close();
                          Toast.show('order has been sent successfully', context, duration: Toast.LENGTH_LONG);
                          }),
                        _prettyButton(model, 'CLEAR CART', (_) {
                          model.clearCart();
                          ExpandingBottomSheet.of(context).close();
                        }),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

Future<void> _sendOrder(AppStateModel model)async{
  final user = Provider.of<User>(context);
  final order = Order(
    products: model.productsToOrder(),
    orderTime: DateTime.now().millisecondsSinceEpoch,
    doctor: user.id,
    state: OrderState.INIT,
  );
  FirestoreService().addOrder(order).then(
    (value) => FirestoreService().setOrderStateTo(order, OrderState.SENT),
    );
}
  Widget _prettyButton(AppStateModel model, String text, Function action) {
    return RaisedButton(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
      ),
      color: kShrinePink100,
      splashColor: kShrineBrown600,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Text(text),
      ),
      onPressed: () => action(model),
    );
  }
}

