import 'package:flutter/material.dart';
import 'package:shop_app/controllers/new_item_controller.dart';
import 'package:shop_app/models/category_model.dart';
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
  Category? _selectedCategory;

  final NewItemController _controller = NewItemController();

  @override
  void initState() {
    super.initState();
    _controller.fetchCategories(setState);
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await NewItemController().saveItem(
        enteredName: _enteredName,
        enteredQuantity: _enteredQuantity,
        selectedCategory: _selectedCategory!,
      );
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
                      value: _selectedCategory,
                      items: [
                        ..._controller.categories.map((category) {
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
                          _selectedCategory = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _selectedCategory = value!;
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
