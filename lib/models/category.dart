import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  const Category(
    String category,
    Color color,
  )   : categoryName = category,
        categoryColor = color;

  final String categoryName;
  final Color categoryColor;
}
