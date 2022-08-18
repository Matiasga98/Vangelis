import 'package:flutter/material.dart';

import 'custom_text.dart';

List<DropdownMenuItem<String>> dropdownListWithDivider(
    Set<String> values, Key key) {
  List<DropdownMenuItem<String>> items = [];
  for (var item in values) {
    items.addAll([
      DropdownMenuItem<String>(
        value: item,
        key: key,
        child: CustomText(item),
      ),
      DropdownMenuItem<String>(
        key: key,
        enabled: false,
        child: const Divider(),
      ),
    ]);
  }
  return items;
}
