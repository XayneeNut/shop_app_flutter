import 'package:flutter/material.dart';

import '../controllers/item_widget_controller.dart';
import '../models/item_models.dart';
import '../theme/text_theme.dart';

class LoadDataWidget extends StatefulWidget {
  const LoadDataWidget({super.key, required this.dummyItems});
    final List<DummyItem> dummyItems;

  @override
  State<LoadDataWidget> createState() => _LoadDataWidgetState();
}

class _LoadDataWidgetState extends State<LoadDataWidget> {
  final ItemWidgetController _itemWidgetController = ItemWidgetController();

  void _removeItem(DummyItem item) async {
    final response = await _itemWidgetController.getDeleteResponse(item);
    final index = widget.dummyItems.indexOf(item);

    setState(() {
      widget.dummyItems.remove(item);
    });

    await _itemWidgetController.removeItem(item);

    if (response.statusCode >= 400) {
      setState(() {
        widget.dummyItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.dummyItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(widget.dummyItems[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _removeItem(widget.dummyItems[index]);
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
                color: widget.dummyItems[index].category.color,
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
            title: Text(widget.dummyItems[index].name, style: styleSignika),
            trailing: Text(
              '${widget.dummyItems[index].quantity}',
              style: styleSignika,
            ),
          ),
        ),
      ),
    );
  }
}
