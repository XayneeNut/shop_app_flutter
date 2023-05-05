import 'package:flutter/material.dart';
import 'package:shop_app/data/categories_data.dart';
import 'package:shop_app/models/categories_models.dart';
import 'package:shop_app/models/item_models.dart';
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
  var _selectedCategory = categories[Categories.other]!;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(
        context,
        DummyItem(
            id: DateTime.now().toString(),
            name: _enteredName,
            quantity: _enteredQuantity,
            category: _selectedCategory),
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
                decoration: InputDecoration(
                  label: const Text('Name'),
                  labelStyle: styleSignika,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 character';
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
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      height: 20,
                                      width: 20,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      category.value.name,
                                      style: styleSignika,
                                    )
                                  ],
                                )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        }),
                  )
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
                    child: const Text('reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: Text(
                      'add item',
                      style: styleSignika.copyWith(
                          fontSize: 14, color: Colors.lightBlueAccent),
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
