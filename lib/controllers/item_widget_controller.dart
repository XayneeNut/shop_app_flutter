import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/item_models.dart';
import 'package:shop_app/theme/hex_color.dart';

class ItemWidgetController {
  Future<List<DummyItem>> loadItem() async {
    final response = await getUrl();
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

  Future<http.Response> getUrl() async {
    final url = Uri.http('10.0.2.2:8123', '/api/v1/item-list/get-all');
    final response = await http.get(url);
    return response;
  }

  Future<http.Response> removeItem(DummyItem item) {
    final deleteUrl =
        Uri.http('10.0.2.2:8123', '/api/v1/item-list/delete/${item.id}');

    final deleteItem = http.delete(deleteUrl);

    return deleteItem;
  }

  Future<http.Response> getDeleteResponse(DummyItem item) async {
    final deleteUrl =
        Uri.http('10.0.2.2:8123', '/api/v1/item-list/delete/${item.id}');

    final response = await http.delete(deleteUrl);
    return response;
  }
}
