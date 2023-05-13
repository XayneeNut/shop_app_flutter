import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Category {
  final String id;
  final String name;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      color: Color(int.parse(json['color'])),
    );
  }
}

