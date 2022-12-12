
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_book_item.dart';
import 'edit_book_screen.dart';

class UserBooksScreen extends StatelessWidget {
  static const routeName = 'user-books';

  Future<void> _refreshBooks(BuildContext context) async {
    await Provider.of<Books>(context, listen: false).fetchAndSetBooks(true);
  }

  @override
  Widget build(BuildContext context) {
    //final booksData = Provider.of<Books>(context);
    print('rebuilding');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 129, 17, 24),
        title: const Text('Your Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditBookScreen.routeName);
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshBooks(context),
        builder: (context, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () => _refreshBooks(context),
          child: Consumer<Books>(
            builder: (context, booksData, _) => Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: booksData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    UserBookItem(
                        booksData.items[i].id,
                        booksData.items[i].title,
                        booksData.items[i].imageUrl),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}