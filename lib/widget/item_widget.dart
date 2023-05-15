import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/item_models.dart';
import 'package:shop_app/theme/hex_color.dart';
import 'package:shop_app/theme/text_theme.dart';
import 'package:shop_app/widget/new_item_widget.dart';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    super.key,
  });

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  final List<DummyItem> _dummyItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.http('10.0.2.2:8123', '/api/v1/item-list/get-all');
    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    List<DummyItem> items = [];
    for (var itemData in jsonData) {
      final itemId = itemData['id'].toString();
      final itemName = itemData['name'];
      final itemQuantity = itemData['quantity'];
      final categoryId = itemData['categoryEntity']['id'].toString();
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

    setState(() {
      _dummyItems.clear();
      _dummyItems.addAll(items);
    });
  }

  void _onAddIcon() async {
    await Navigator.push<DummyItem>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewItemWidget(),
      ),
    );

    _loadItems();
  }

  void _removeItem(DummyItem item) {
    setState(() {
      _dummyItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'there are no item added',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    if (_dummyItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _dummyItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_dummyItems[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _removeItem(_dummyItems[index]);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            leading: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _dummyItems[index].category.color,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(
                      3.0,
                      3.0,
                    ),
                    blurRadius: 3.0,
                    spreadRadius: 0.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
            ),
            title: Text(_dummyItems[index].name, style: styleSignika),
            trailing: Text(
              '${_dummyItems[index].quantity}',
              style: styleSignika,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'list item',
          style:
              styleSignika.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _onAddIcon,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
