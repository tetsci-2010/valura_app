import 'package:flutter/material.dart';
import 'package:valura/features/screens/main_screens/add_item_screen/add_item_screen.dart';
import 'package:valura/features/screens/main_screens/create_item_screen/create_item_screen.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:valura/features/screens/main_screens/items_screen/items_screen.dart';

List<Widget> screens = [
  HomeScreen(),
  CreateItemScreen(),
  ItemsScreen(),
  AddItemScreen(),
];

List<IconData> homeNavBtns = [
  Icons.home_outlined,
  Icons.add,
  Icons.view_list_rounded,
  Icons.account_tree_outlined,
];
