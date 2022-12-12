import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/customer.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart';
import 'order_success_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  final _form = GlobalKey<FormState>();
  var _customerDetails = Customer(
    name: '',
    phoneNumber: '',
    pinCode: '',
    locality: '',
    address: '',
    cityOrTown: '',
    landmark: '',
  );

  Future<void> _placeOrder(CartProvider cart) async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    await Provider.of<Orders>(context, listen: false).addOrders(
        cart.items.values.toList(), cart.totalAmount, _customerDetails);
    setState(() {
      _isLoading = false;
    });
    cart.clear();
    Navigator.of(context).pushReplacementNamed(OrderSuccessful.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 129, 17, 24),
        title: Text('your Cart'),
      ),
      body:ListView.builder(
          itemCount: cart.items.length + 1,
          itemBuilder: (context, i) {
            if (cart.items.isEmpty) {
              return Center(
                  child: Text('Your cart is empty',
                      style: TextStyle(fontSize: 20)));
            }
            if (i == cart.items.length) {
              return inputform(cart);
            }
            return CartItemWidget(
                id:cart.items.values.toList()[i].id,
                price:cart.items.values.toList()[i].price,
                quantity:cart.items.values.toList()[i].quantity,
                title:cart.items.values.toList()[i].title,
                image:cart.items.values.toList()[i].image,
              bookId: cart.items.values.toList()[i].bookId,);
          }),
    );
  }

  Container inputform(CartProvider cart) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 219, 215, 215)),
        color: Colors.white,
      ),
      child: Form(
        key: _form,
        child: Column(
          children: [
            Row(
              children: [
                Text('Customer Details',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_drop_down))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                         TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.grey)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a Name.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _customerDetails = Customer(
                                name: value!,
                                phoneNumber: _customerDetails.phoneNumber,
                                pinCode: _customerDetails.pinCode,
                                locality: _customerDetails.locality,
                                address: _customerDetails.address,
                                cityOrTown: _customerDetails.cityOrTown,
                                landmark: _customerDetails.landmark);
                          },
                        ),
                      ],
                    )),
                SizedBox(width: 5),
                Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefix: Text('+91 '),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.grey)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a Phone Number.';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _customerDetails = Customer(
                                name: _customerDetails.name,
                                phoneNumber: value!,
                                pinCode: _customerDetails.pinCode,
                                locality: _customerDetails.locality,
                                address: _customerDetails.address,
                                cityOrTown: _customerDetails.cityOrTown,
                                landmark: _customerDetails.landmark);
                          },
                        ),
                      ],
                    ))
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Pin Code',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.grey)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a Pin Code.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _customerDetails = Customer(
                                name: _customerDetails.name,
                                phoneNumber: _customerDetails.phoneNumber,
                                pinCode: value!,
                                locality: _customerDetails.locality,
                                address: _customerDetails.address,
                                cityOrTown: _customerDetails.cityOrTown,
                                landmark: _customerDetails.landmark);
                          },
                        ),
                      ],
                    )),
                SizedBox(width: 5),
                Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Locality',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.grey)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _customerDetails = Customer(
                                name: _customerDetails.name,
                                phoneNumber: _customerDetails.phoneNumber,
                                pinCode: _customerDetails.pinCode,
                                locality: value!,
                                address: _customerDetails.address,
                                cityOrTown: _customerDetails.cityOrTown,
                                landmark: _customerDetails.landmark);
                          },
                        ),
                      ],
                    ))
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.blue)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.grey)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        textInputAction: TextInputAction.next,

                        //keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _customerDetails = Customer(
                              name: _customerDetails.name,
                              phoneNumber: _customerDetails.phoneNumber,
                              pinCode: _customerDetails.pinCode,
                              locality: _customerDetails.locality,
                              address: value!,
                              cityOrTown: _customerDetails.cityOrTown,
                              landmark: _customerDetails.landmark);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'City/Town',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.grey)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _customerDetails = Customer(
                                name: _customerDetails.name,
                                phoneNumber: _customerDetails.phoneNumber,
                                pinCode: _customerDetails.pinCode,
                                locality: _customerDetails.locality,
                                address: _customerDetails.address,
                                cityOrTown: value!,
                                landmark: _customerDetails.landmark);
                          },
                        ),
                      ],
                    )),
                SizedBox(width: 5),
                Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Landmark',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.grey)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _customerDetails = Customer(
                              name: _customerDetails.name,
                              phoneNumber: _customerDetails.phoneNumber,
                              pinCode: _customerDetails.pinCode,
                              locality: _customerDetails.locality,
                              address: _customerDetails.address,
                              cityOrTown: _customerDetails.cityOrTown,
                              landmark: value!,
                            );
                          },
                        ),
                      ],
                    ))
              ],
            ),
            Row(children: [
              Spacer(),
              ElevatedButton(
                onPressed: (cart.totalAmount <= 0 || _isLoading)
                    ? null
                    : () async {
                  await _placeOrder(cart);
                },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('PLACE ORDER'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}