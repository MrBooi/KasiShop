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
  bool _isinit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    }
    setState(() {
      _isinit = false;
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, index) => OrderItem(
                order: orderData.orders[index],
              ),
            ),
    );
  }
}
