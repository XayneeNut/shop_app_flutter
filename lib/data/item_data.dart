
import 'package:shop_app/data/categories_data.dart';
import 'package:shop_app/models/item_models.dart';

import '../models/categories_models.dart';

final groceryItems = [
  DummyItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  DummyItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  DummyItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];