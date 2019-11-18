import 'package:flutter/material.dart';
import 'package:kasishop/widgets/app_drawer.dart';
import 'package:kasishop/widgets/order_item.dart';

import 'package:provider/provider.dart';

import 'package:kasishop/providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataSnapshot.error != null) {
              return Center(
                child: Text('Opps Something bad occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) => OrderItem(
                    order: orderData.orders[index],
                  ),
                ),
              );
            }
          },
        ));
  }
}
