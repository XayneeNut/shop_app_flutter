
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/category_model.dart';

class NewItemController{
  List<Category> categories = [];

  Future<void> fetchCategories(Function setState) async {
    final url = Uri.http('10.0.2.2:8123', '/api/v1/category/get-all');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      final fetchedCategories = jsonData.map((categoryJson) {
        final colorHex = categoryJson['color'] as String;
        final colorValue = int.tryParse(colorHex.substring(1), radix: 16);
        final color =
            colorValue != null ? Color(colorValue) : Colors.transparent;
        return Category(
          id: categoryJson['id'].toString(),
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
        // Do something, such as showing a success message or navigating to a different screen
      } else {
        throw Exception('Failed to save item');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }
}