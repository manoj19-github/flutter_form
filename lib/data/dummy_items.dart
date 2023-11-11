import 'package:fluttter_form/models/category.dart';
import 'package:flutter/material.dart';

import 'package:fluttter_form/models/category.dart';
import 'package:fluttter_form/data/categories.dart';
import 'package:fluttter_form/models/grocery_item.dart';


final groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: '1',
      category: categories[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: '5',
      category: categories[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: '1',
      category: categories[Categories.meat]!),
];