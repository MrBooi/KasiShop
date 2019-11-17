import 'package:flutter/material.dart';
import 'package:kasishop/providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _decriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  var _editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0);

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);

        _initialValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl
        };

        _imageUrlController.text = _initialValues['imageUrl'];
      }

      setState(() {
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _decriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Text',
                  ),
                  initialValue: _initialValues['title'],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a text';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        title: value,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        description: _editedProduct.description);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  initialValue: _initialValues['price'],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) < 0) {
                      return 'Please enter number greater than zero';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_decriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        title: _editedProduct.title,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(value),
                        description: _editedProduct.description);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  initialValue: _initialValues['description'],
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a description';
                    }
                    if (value.length < 10) {
                      return 'Description should be at least 10 characters long';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  focusNode: _decriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                        title: _editedProduct.title,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        description: value);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a Url')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a image URL';
                          }

                          if (!value.startsWith('https') ||
                              !value.startsWith('http')) {
                            return 'Please enter a valid URL';
                          }

                          // if (!value.endsWith('.png') ||
                          //     !value.endsWith('.jpg') ||
                          //     !value.endsWith('.jpge')) {
                          //   return 'Please enter a valid URL';
                          // }

                          return null;
                        },
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              imageUrl: value,
                              price: _editedProduct.price,
                              description: _editedProduct.description);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
