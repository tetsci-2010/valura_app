import 'package:flutter/material.dart';
import 'package:valura/features/screens/main_screens/add_item_screen/add_item_screen.dart';
import 'package:valura/features/screens/main_screens/create_item_screen/create_item_screen.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';

List<Widget> screens = [
  AddItemScreen(),
  HomeScreen(),
  CreateItemScreen(),
];

List<IconData> homeNavBtns = [
  Icons.playlist_add_rounded,
  Icons.home_outlined,
  Icons.list,
];
