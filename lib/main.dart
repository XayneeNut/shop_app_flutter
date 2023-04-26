import 'package:flutter/material.dart';
import 'package:shop_app/theme/text_theme.dart';
import 'package:shop_app/widget/item_widget.dart';

void main(List<String> args) {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: ThemeData.dark().copyWith(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 147, 229, 250),
              brightness: Brightness.dark,
              surface: const Color.fromARGB(255, 42, 51, 59),
            ),
            scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
            textTheme: josefinSansFontFamily.textTheme),
        home: const ItemWidget());
  }
}
