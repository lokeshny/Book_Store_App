import 'package:book_store_apppp/providers/auth.dart';
import 'package:book_store_apppp/providers/books.dart';
import 'package:book_store_apppp/providers/cart.dart';
import 'package:book_store_apppp/providers/orders.dart';
import 'package:book_store_apppp/screens/auth_screen.dart';
import 'package:book_store_apppp/screens/books_overview_screen.dart';
import 'package:book_store_apppp/screens/cart_screen.dart';
import 'package:book_store_apppp/screens/edit_book_screen.dart';
import 'package:book_store_apppp/screens/order_screen.dart';
import 'package:book_store_apppp/screens/order_success_screen.dart';
import 'package:book_store_apppp/screens/splash_screen.dart';
import 'package:book_store_apppp/screens/user_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers/custome_rout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Books>(
            create: (_) => Books(null, '', []),
            update: (context, auth, previousBooks) {
              return Books(
                auth.token ?? '',
                auth.userId,
                previousBooks == null ? [] : previousBooks.items,
              );
            }),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, '', []),
          update: (ctx, auth, previousOrders) {

            return Orders(
              auth.token ?? '',
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            );
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'BookStore',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? BookOverviewScreen()
              : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (context, authResultSnapshot) =>
              authResultSnapshot.connectionState ==
                  ConnectionState.waiting
                  ? SplashScreen()
                  : AuthScreen()),
          routes: {
            //   ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            OrderSuccessful.routeName: (context) => OrderSuccessful(),
            UserBooksScreen.routeName: (context) => UserBooksScreen(),
            EditBookScreen.routeName: (context) => EditBookScreen(),
          },
        ),
      ),
    );
  }
}