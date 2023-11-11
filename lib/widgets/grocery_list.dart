import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttter_form/data/categories.dart';
import 'package:fluttter_form/data/dummy_items.dart';
import 'package:fluttter_form/models/category.dart';
import 'package:fluttter_form/models/grocery_item.dart';
import 'package:fluttter_form/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryStateList extends StatefulWidget {
  @override
  State<GroceryStateList> createState() => GroceryList();
}

class GroceryList extends State<GroceryStateList> {
  List<GroceryItem> _groceryItems = [];
  Widget? content;
  var _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'learn-flutter-36eca-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');

    try {
      final response = await http.get(url);
      print(response.body);
      final listData = json.decode(response.body);
      final List<GroceryItem> loadedItemList = [];

      for (final list in listData.entries) {
        final localCategory = categories.entries
            .firstWhere((self) => self.value.title == list.value['category'])
            .value;
        loadedItemList.add(GroceryItem(
            id: list.key,
            name: list.value['name'],
            quantity: list.value['quantity'],
            category: localCategory));
      }

      setState(() {
        _groceryItems = loadedItemList;
        _isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void addItem() async {
    final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItem()));
    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    if (_groceryItems.isNotEmpty) {
      content = Scaffold(
          appBar: AppBar(
            title: const Text('My Grocery'),
            actions: [
              IconButton(onPressed: addItem, icon: const Icon(Icons.add))
            ],
          ),
          body: ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) => ListTile(
                    title: Text(_groceryItems[index].name),
                    leading: Container(
                        width: 24,
                        height: 24,
                        color: _groceryItems[index].category.color),
                    trailing: Text(_groceryItems[index].quantity.toString(),
                        style: TextStyle(fontSize: 18)),
                  )));
    }
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    return content!;

    // TODO: implement build
  }
}
