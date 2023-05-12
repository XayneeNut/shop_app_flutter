import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/theme/text_theme.dart';

class NewItemWidget extends StatefulWidget {
  const NewItemWidget({super.key});

  @override
  State<NewItemWidget> createState() => _NewItemWidgetState();
}

class _NewItemWidgetState extends State<NewItemWidget> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory;

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories = [];
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = Uri.http('10.0.2.2:8123', '/api/v1/category/get-all');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      final categories = jsonData.map((categoryJson) {
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
        _categories = categories;
      });
    } else {
      // Handle error case
    }
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.http('10.0.2.2:8123', '/api/v1/item-list/create');

      final body = json.encode({
        'name': _enteredName,
        'quantity': _enteredQuantity,
        'categoryEntityId': _selectedCategory.id,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Item successfully saved
        // Do something, such as showing a success message or navigating to a different screen
      } else {
        // Handle error case
        // You can check response.statusCode and response.body for more details on the error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a new item',
          style: styleSignika.copyWith(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  label: const Text('Name'),
                  labelStyle: styleSignika,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: styleSignika.copyWith(fontSize: 16),
                      decoration: InputDecoration(
                        label: Text(
                          'Quantity',
                          style: styleSignika.copyWith(fontSize: 20),
                        ),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      items: _categories.map((category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                height: 20,
                                width: 20,
                                color: category.color,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                category.name,
                                style: styleSignika,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (Category? value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _selectedCategory = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: Text(
                      'ADD ITEM',
                      style: styleSignika.copyWith(
                          fontSize: 12, color: Colors.lightBlueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  final String id;
  final String name;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      color: Color(int.parse(json['color'])),
    );
  }
}
