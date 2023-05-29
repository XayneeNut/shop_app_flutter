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
  final ItemWidgetController _itemWidgetController = ItemWidgetController();
  var _isLoading = true;
  String? onError;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    bool isErrorDisplayed = false;
    Timer(const Duration(seconds: 3), () {
      // Code yang menandakan koneksinya tidak bisa dijangkau / connection refused
      if (_isLoading && !isErrorDisplayed) {
        setState(() {
          onError = 'Connection Refused. Please try again later.';
        });
      }
    });

    try {
      List<DummyItem> items = await _itemWidgetController.loadItem();
      final response = await _itemWidgetController.getUrl();

      if (!_isLoading) {
        // return akan lebih awal jika loading sudah selesai
        return;
      }

      isErrorDisplayed = true; // ini untuk atur teks widget jika api eror
      if (response.statusCode >= 400) {
        setState(() {
          onError =
              'Failed to fetch data from the server. Please try again later.';
        });
      } else {
        setState(() {
          _dummyItems.clear();
          _dummyItems.addAll(items);
          _isLoading = false;
        });
      }
    } catch (error) {
      if (!_isLoading) {
        //  return akan lebih awal jika loading sudah selesai
        return;
      }

      isErrorDisplayed = true; // ini untuk atur teks widget jika api eror
      setState(() {
        onError =
            'Failed to fetch data from the server. Please try again later.';
      });
    }
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

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_dummyItems.isNotEmpty) {
      content = LoadDataWidget(dummyItems: _dummyItems);
    }

    if (onError != null) {
      content = Center(
        child: Text(
          onError!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
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
