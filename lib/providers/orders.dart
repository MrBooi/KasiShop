import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String _authToken;
  final String _userId;

  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shop-app-f2611.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        extractedData.forEach((orderId, orderData) {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['Products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'].toString(),
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
                  )
                  .toList(),
            ),
          );
        });
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shop-app-f2611.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'Products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }),
      );
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timestamp,
            products: cartProducts),
      );
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
