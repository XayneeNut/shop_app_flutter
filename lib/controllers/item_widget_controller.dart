import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/item_models.dart';
import 'package:shop_app/theme/hex_color.dart';

class ItemWidgetController {
  Future<List<DummyItem>> loadItem() async {
    final url = Uri.http('10.0.2.2:8123', '/api/v1/item-list/get-all');
    final response = await http.get(url);
    final jsonData = json.decode(response.body);
    String? onError;

    if (response.statusCode >= 400) {
      onError = 'failed connect to server. please try again later';
    }

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
