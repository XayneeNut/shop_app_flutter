import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/item_widget_controller.dart';
import 'package:shop_app/controllers/new_item_controller.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/theme/text_theme.dart';
import 'package:shop_app/models/item_models.dart';
import 'package:shop_app/widget/form_widget.dart';


class NewItemWidget extends StatefulWidget {
  const NewItemWidget({super.key});

  @override
  State<NewItemWidget> createState() => _NewItemWidgetState();
}

class _NewItemWidgetState extends State<NewItemWidget> {
  Category? _selectedCategory;

  final NewItemController _newItemController = NewItemController();
  final ItemWidgetController _itemWidgetController = ItemWidgetController();

  @override
  void initState() {
    super.initState();
    _newItemController.fetchCategories(setState);
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
        child: FormWidget(selectedCategory: _selectedCategory, newItemController: _newItemController, itemWidgetController: _itemWidgetController)
      ),
    );
  }
}
