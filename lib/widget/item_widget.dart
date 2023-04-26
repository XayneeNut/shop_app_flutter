import 'package:flutter/material.dart';
import 'package:shop_app/data/categories_data.dart';
import 'package:shop_app/data/item_data.dart';
import 'package:shop_app/theme/text_theme.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('list item'),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: categories[groceryItems[index].category]!.color,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(
                    5.0,
                    5.0,
                  ), //Offset
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
            ),
          ),
          title: Text(groceryItems[index].name, style: styleSignika),
          trailing: Text(
            '${groceryItems[index].quantity}',
            style: styleSignika,
          ),
        ),
      ),
    );
  }
}
