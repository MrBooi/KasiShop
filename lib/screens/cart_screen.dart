import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cartData.totalamount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      child: Text('ORDER NOW'),
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrders(
                            cartData.item.values.toList(),
                            cartData.totalamount);

                        cartData.clearCart();
                      },
                      textColor: Theme.of(context).primaryColor,
                    )
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cartData.item.length,
                itemBuilder: (ctx, index) {
                  var data = cartData.item.values.toList()[index];
                  return CartItem(
                      id: data.id,
                      productId: cartData.item.keys.toList()[index],
                      title: data.title,
                      price: data.price,
                      quantity: data.quantity);
                }),
          )
        ],
      ),
    );
  }
}
