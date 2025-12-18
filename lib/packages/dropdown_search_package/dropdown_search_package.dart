import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownSearchPackage {
  static Widget dropdownSearch<T>({
    void Function(T? item)? onChanged,
    Widget Function(BuildContext context, T? item)? dropdownBuilder,
    bool enabled = true,
    String Function(T item)? itemAsString,
    Mode mode = Mode.form,
    T? selectedItem,
    String? Function(T? item)? validator,
    Widget Function(BuildContext context, T item, bool isDisabled, bool isSelected)? itemBuilder,
    FutureOr<List<T>> Function(String filter, LoadProps? loadProps)? items,
    bool showSearchBox = true,
  }) {
    try {
      return DropdownSearch<T>(
        compareFn: (item1, item2) => item1 == item2,
        onChanged: onChanged,
        decoratorProps: DropDownDecoratorProps(),
        items: items,
        popupProps: PopupProps.menu(
          containerBuilder: (context, popupWidget) {
            return Container(
              decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
              child: popupWidget,
            );
          },
          showSearchBox: showSearchBox,
          emptyBuilder: (context, searchEntry) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search),
                  Text('جستجو کنید'),
                ],
              ),
            );
          },
          itemBuilder: itemBuilder,
          loadingBuilder: (context, searchEntry) {
            return Center(child: CircularProgressIndicator());
          },
        ),
        dropdownBuilder: dropdownBuilder,
        enabled: enabled,
        itemAsString: itemAsString,
        mode: mode,
        selectedItem: selectedItem,
        validator: validator,
      );
    } catch (e) {
      return SizedBox();
    }
  }
}
