import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String bookId;
  final double price;
  final int quantity;
  final String title;
  final String image;
  CartItemWidget({
    required this.id,
    required this.bookId,
    required this.price,
    required this.quantity,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 219, 215, 215)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('My cart',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Image.network(
                image,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 50),
              Text(title),
              Text('Total: Rs. ${price * quantity}'),
              Row(
                children: <Widget>[
                  quantity > 1
                      ? GestureDetector(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 224, 219, 219),
                        borderRadius:
                        BorderRadiusDirectional.circular(100),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    ),
                    onTap: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .removeSingleItem(bookId);
                    },
                  )
                      : SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      '$quantity',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 224, 219, 219),
                        borderRadius: BorderRadiusDirectional.circular(100),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    ),
                    onTap: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addItem(bookId, price, title, image);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              const SizedBox(height: 160),
              GestureDetector(
                  child: Text('Remove'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text(
                            'Do you want to remove the item from the cart?'),
                        actions: [
                          ElevatedButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeItem(bookId);
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
          const SizedBox(width: 5)
        ],
      ),
    );
  }
}