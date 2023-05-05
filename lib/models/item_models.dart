import 'package:shop_app/models/categories_models.dart';

class DummyItem {
  const DummyItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});

  final String id;
  final String name;
  final int quantity;
  final Category category;
}
