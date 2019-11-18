import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kasishop/models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((item) => item.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-app-f2611.firebaseio.com/products.json';
    try {
      final respose = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite
        }),
      );
      final newProduct = Product(
          id: json.decode(respose.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> editProduct(String productId, Product product) async {
    final url =
        'https://shop-app-f2611.firebaseio.com/products/$productId.json';
    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      final productIndex =
          _items.indexWhere((productItem) => productItem.id == productId);
      if (productIndex >= 0) {
        _items[productIndex] = product;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product findById(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  Future<void> deleteProduct(String _id) async {
    final url = 'https://shop-app-f2611.firebaseio.com/products/$_id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == _id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    final response = await http.delete(url);
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://shop-app-f2611.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final List<Product> loadedProducts = [];
      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: prodData['isFavorite']));
        });
        _items = loadedProducts;

        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}
