import 'dart:convert';

import 'package:flutter/material.dart';

import '../controllers/item_widget_controller.dart';
import '../controllers/new_item_controller.dart';
import '../models/category_model.dart';
import '../models/item_models.dart';
import '../theme/text_theme.dart';

class FormWidget extends StatefulWidget {
  FormWidget(
      {super.key,
      required this.selectedCategory,
      required this.newItemController,
      required this.itemWidgetController});
  Category? selectedCategory;
  final NewItemController newItemController;
  final ItemWidgetController itemWidgetController;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  var _isSending = false;
  var _enteredName = '';
  var _enteredQuantity = 1;
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveItem() async {
    final response = await widget.itemWidgetController.getUrl();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await widget.newItemController.saveItem(
        enteredName: _enteredName,
        enteredQuantity: _enteredQuantity,
        selectedCategory: widget.selectedCategory!,
      );

      final items = await widget.newItemController.loadItem();
      setState(() {
        widget.newItemController.items = items;
        _isSending = true;
      });

      if (!context.mounted) return;

      final jsonData = json.decode(response.body) as List<dynamic>;
      final firstItem = jsonData.first;
      final itemListId = firstItem['itemListId'];

      Navigator.pop(
        context,
        DummyItem(
          id: itemListId.toString(),
          name: _enteredName,
          quantity: _enteredQuantity,
          category: widget.selectedCategory!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              maxLines: 3,
              minLines: 1,
              style: styleSignika,
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
                    value: widget.selectedCategory,
                    items: [
                      ...widget.newItemController.categories.map((category) {
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
                      DropdownMenuItem(
                          value: null,
                          child: Text(
                            'Select a category',
                            style: styleSignika,
                          ))
                    ],
                    onChanged: (Category? value) {
                      setState(() {
                        widget.selectedCategory = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.selectedCategory = value!;
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
                  onPressed: _isSending
                      ? null
                      : () {
                          _formKey.currentState!.reset();
                        },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _isSending ? null : _saveItem,
                  child: _isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
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
    );
  }
}
