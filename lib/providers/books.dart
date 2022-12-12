
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'book.dart';

class Books with ChangeNotifier {
  final String? authToken;
  final String userId;

  Books(this.authToken, this.userId, this._items);

  List<Book> _items = [
    // Book(
    //   id: "1",
    //   imageUrl:
    //       "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //   title: "Building Planning",
    //   author: "S. S. Bhavikatti",
    //   price: 1400,
    // ),
    // Book(
    //   id: "2",
    //   imageUrl:
    //       "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //   title: "Civil Engineering",
    //   author: "S. P. Gupta",
    //   price: 1200,
    // ),
    // Book(
    //     id: "3",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Surveying",
    //     author: "S. K. Duggal",
    //     price: 1000),
    // Book(
    //   id: "5",
    //   imageUrl:
    //       "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //   title: "Rising hear",
    //   author: "Perumal",
    //   price: 400,
    // ),
    // Book(
    //     id: "6",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Just like you",
    //     author: "Nick Hornby",
    //     price: 500),
    // Book(
    //     id: "7",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Richest man",
    //     author: "George S. Clason",
    //     price: 600),
    // Book(
    //     id: "9",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Chinese Communist",
    //     author: "Handry",
    //     price: 200),
    // Book(
    //     id: "10",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Think like a Rocket",
    //     author: "Panik H.",
    //     price: 800),
    // Book(
    //     id: "11",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "How to speak",
    //     author: "Ron Malhotra",
    //     price: 850),
    // Book(
    //     id: "12",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Wining like Sourav",
    //     author: "Abhirup B.",
    //     price: 880),
    // Book(
    //     id: "13",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Oxfort Avanced",
    //     author: "Ajit J.",
    //     price: 1100),
    // Book(
    //     id: "14",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Tip of the Iceberg",
    //     author: "Suveen Sinha",
    //     price: 690),
    // Book(
    //     id: "15",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "How to read a book",
    //     author: "Nortimer J. Adler",
    //     price: 780),
    // Book(
    //     id: "16",
    //     imageUrl:
    //         "https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-open-book-image_1134778.jpg",
    //     title: "Winning Sachin",
    //     author: "Devendra P.",
    //     price: 450)
  ];

  List<Book> get items {
    return [..._items];
  }

  Book findById(String id) {
    return _items.firstWhere((book) => book.id == id);
  }

  Future<void> fetchAndSetBooks([bool filterByUser = false]) async {
    final filterString =
    filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        "https://book-store-app-fd8e5-default-rtdb.asia-southeast1.firebasedatabase.app/books.json?auth=$authToken&$filterString";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Book> loadedBooks = [];
      extractedData.forEach(
            (bookId, bookData) {
          loadedBooks.add(Book(
            id: bookId,
            imageUrl: bookData['imageUrl'],
            title: bookData['title'],
            author: bookData['author'],
            price: bookData['price'],
          ));
        },
      );
      _items = loadedBooks;
      notifyListeners();
      // print(json.decode(response.body));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addBook(Book book) async {
    final url =
        "https://book-store-app-fd8e5-default-rtdb.asia-southeast1.firebasedatabase.app/books.json?auth=$authToken";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': book.title,
          'author': book.author,
          'price': book.price,
          'imageUrl': book.imageUrl,
          'creatorId': userId,
        }),
      );
      final newBook = Book(
        id: json.decode(response.body)['name'],
        title: book.title,
        author: book.author,
        price: book.price,
        imageUrl: book.imageUrl,
      );
      _items.add(newBook);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    // print(error);
    // throw error;
  }

  Future<void> updateBook(String id, Book newBook) async {
    final bookIndex = _items.indexWhere((book) => book.id == id);
    if (bookIndex >= 0) {
      final url =
          'https://book-store-app-fd8e5-default-rtdb.asia-southeast1.firebasedatabase.app/books/$id.json?auth=$authToken';
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': newBook.title,
          'author': newBook.author,
          'price': newBook.price,
          'imageUrl': newBook.imageUrl,
        }),
      );
      _items[bookIndex] = newBook;
      notifyListeners();
    } else {
      print('....');
    }
    notifyListeners();
  }

  Future<void> deleteBook(String id) async {
    final url =
        'https://book-store-app-fd8e5-default-rtdb.asia-southeast1.firebasedatabase.app/books/$id.json?auth=$authToken';
    final existingBookIndex = _items.indexWhere((book) => book.id == id);
    Book? existingBook = _items[existingBookIndex];
    _items.removeAt(existingBookIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingBookIndex, existingBook);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingBook = null;
  }
}