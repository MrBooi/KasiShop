import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:kasishop/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _isExpanded ? min(widget.order.products.length * 20.0 + 120, 240) : 98,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            if (_isExpanded)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isExpanded? min(widget.order.products.length * 20.0 + 10, 120) : 0.0,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: ListView(
                  children: widget.order.products
                      .map(
                        (item) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                item.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${item.quantity}x \$${item.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              )
                            ]),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
