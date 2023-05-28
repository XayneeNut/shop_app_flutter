import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/item_widget_controller.dart';
import 'package:shop_app/models/item_models.dart';
import 'package:shop_app/theme/text_theme.dart';
import 'package:shop_app/widget/load_data_widget.dart';
import 'package:shop_app/widget/new_item_widget.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  final List<DummyItem> _dummyItems = [];
  late Future<List<DummyItem>> _loadedItems;
  final ItemWidgetController _itemWidgetController = ItemWidgetController();
  String? onError;

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }

  Future<List<DummyItem>> _loadItems() async {
    List<DummyItem> items = await _itemWidgetController.loadItem();
    final response = await _itemWidgetController.getUrl();

    if (response.statusCode >= 400) {
      throw 'failed to connect to the server, please try again later';
    }
    return items;
  }

  void _onAddIcon() async {
    final newItem = await Navigator.push<DummyItem>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewItemWidget(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _dummyItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Text('there are no item added',
                style: TextStyle(color: Colors.white, fontSize: 20));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return LoadDataWidget();
        },
      ),
    );
  }
}
