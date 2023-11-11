import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttter_form/data/categories.dart';
import 'package:fluttter_form/models/category.dart';
import 'package:fluttter_form/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  var _title;
  var _quantity;
  var _category;
  Map<String, dynamic> responsePayload = {};
  final _formKey = GlobalKey<FormState>();
  void saveFormHandler() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var payload = {
        'name': _title,
        'quantity': _quantity,
        'category': _category!.title
      };
      final url = Uri.https(
          'learn-flutter-36eca-default-rtdb.asia-southeast1.firebasedatabase.app',
          'shopping-list.json');
      print(url);
      try {
        final response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(payload));
        print(response.statusCode);
        final Map<String, dynamic> res = json.decode(response.body);
        responsePayload = {'id': res['name'], ...payload};
        if (!context.mounted) return;
        Navigator.of(context).pop(GroceryItem(
            id: res['name'],
            name: _title,
            quantity: _quantity,
            category: _category));
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item.')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50)
                        return 'Must be between 1 to 50 character';
                    },
                    onSaved: (value) {
                      _title = value;
                    }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Quantity'),
                          ),
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _quantity = value;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0)
                              return 'Must be between 1 to 50 character';
                          }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField(
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                      width: 12,
                                      height: 12,
                                      color: category.value.color),
                                  const SizedBox(width: 6),
                                  Text(category.value.title),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          print(value!.title);
                          _category = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text('Reset')),
                    ElevatedButton(
                        onPressed: saveFormHandler,
                        child: const Text('Add item')),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
