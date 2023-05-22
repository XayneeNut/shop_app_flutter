import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/theme/hex_color.dart';

import '../models/item_models.dart';

class NewItemController {
  List<Category> categories = [];
  var enteredName = '';
  var enteredQuantity = 1;
   List<DummyItem> items = [];

  Future<void> fetchCategories(Function setState) async {
    final url = Uri.http('10.0.2.2:8123', '/api/v1/category/get-all');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      final fetchedCategories = jsonData.map((categoryJson) {
        final colorHex = categoryJson['color'];
        final color = HexColor(colorHex);
        return Category(
          id: categoryJson['categoryId'],
          name: categoryJson['name'],
          color: color,
        );
      }).toList();
      setState(() {
        categories = fetchedCategories;
      });
    } else {
      // Handle error case
    }
  }

    Future<void> saveItem({
    required String enteredName,
    required int enteredQuantity,
    required Category selectedCategory,
  }) async {
    final url = Uri.http('10.0.2.2:8123', '/api/v1/item-list/create');

    final body = json.encode({
      'name': enteredName,
      'quantity': enteredQuantity,
      'categoryEntityId': selectedCategory.id,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Item successfully saved
        // Do something, such as showing a success message
      } else {
        throw Exception('Failed to save item');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<DummyItem>> loadItem() async {
    final url = Uri.http('10.0.2.2:8123', '/api/v1/item-list/get-all');
    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    List<DummyItem> items = [];
    for (var itemData in jsonData) {
      final itemId = itemData['itemListId'].toString();
      final itemName = itemData['name'];
      final itemQuantity = itemData['quantity'];
      final categoryId = itemData['categoryEntity']['categoryId'];
      final categoryColor = itemData['categoryEntity']['color'];

      final dummyItem = DummyItem(
        id: itemId,
        name: itemName,
        quantity: itemQuantity,
        category: Category(
          id: categoryId,
          name: '',
          color: HexColor(categoryColor),
        ),
      );
      items.add(dummyItem);
    }
    return items;
  }
}