import 'dart:convert';

import 'package:book_store_apppp/providers/cart.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../widgets/cart_item.dart';
import 'customer.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final Customer customer;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    required this.customer,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://book-store-app-fd8e5-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(extractedData);
    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                id: item['id'],
                bookId:item['bookId'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
                image: item['image']))
                .toList(),
            customer: Customer.fromJson(orderData['customer'])
          //Customer.fromJson(orderData['customers'])
          // .map((customer) => Customer(
          //     name: customer['name'],
          //     phoneNumber: customer['phoneNumber'],
          //     pinCode: customer['pinCode'],
          //     locality: customer['locality'],
          //     address: customer['address'],
          //     cityOrTown: customer['cityOrTown'],
          //     landmark: customer['landmark']))
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total,
      Customer customerDetails) async {
    final url =
        "https://book-store-app-fd8e5-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken";
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price,
          'image': cp.image,
        })
            .toList(),
        'customer': {
          'name': customerDetails.name,
          'phoneNumber': customerDetails.phoneNumber,
          'pinCode': customerDetails.pinCode,
          'locality': customerDetails.locality,
          'address': customerDetails.address,
          'cityOrTown': customerDetails.cityOrTown,
          'landmark': customerDetails.landmark,
        }
      }),
    );
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
          customer: customerDetails),
    );
    notifyListeners();
  }
}