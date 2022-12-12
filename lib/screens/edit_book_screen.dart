
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book.dart';
import '../providers/books.dart';

class EditBookScreen extends StatefulWidget {
  static const String routeName = '/edit-book';

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _priceFocusNode = FocusNode();
  final _authorFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedBook = Book(
    id: '',
    title: '',
    author: '',
    price: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'author': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final bookId = ModalRoute.of(context)?.settings.arguments;
      if (bookId != null) {
        final id = bookId as String;
        _editedBook = Provider.of<Books>(context, listen: false).findById(id);
        _initValues = {
          'title': _editedBook.title,
          'author': _editedBook.author,
          'price': _editedBook.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedBook.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _authorFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedBook.id != '') {
      await Provider.of<Books>(context, listen: false)
          .updateBook(_editedBook.id, _editedBook);
    } else {
      try {
        await Provider.of<Books>(context, listen: false).addBook(_editedBook);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book'),
        backgroundColor: Color.fromARGB(255, 129, 17, 24),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_authorFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedBook = Book(
                    id: _editedBook.id,
                    title: value!,
                    author: _editedBook.author,
                    price: _editedBook.price,
                    imageUrl: _editedBook.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['author'],
                decoration: InputDecoration(labelText: 'Author'),
                textInputAction: TextInputAction.next,
                focusNode: _authorFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedBook = Book(
                    id: _editedBook.id,
                    title: _editedBook.title,
                    author: value!,
                    price: _editedBook.price,
                    imageUrl: _editedBook.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater then zero.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedBook = Book(
                    id: _editedBook.id,
                    title: _editedBook.title,
                    author: _editedBook.author,
                    price: double.parse(value!),
                    imageUrl: _editedBook.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please entera valid URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter valid image URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBook = Book(
                          id: _editedBook.id,
                          title: _editedBook.title,
                          author: _editedBook.author,
                          price: _editedBook.price,
                          imageUrl: value!,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}