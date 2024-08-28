import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class IBanner {
  final String id;
  final String name;
  final Color backgroundColor;
  final String url;
  final String imageUrl;

  const IBanner({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.url,
    required this.imageUrl,
  });

  factory IBanner.fromJson(Map<String, dynamic> json) => IBanner(
    id: json["id"],
    name: json["name"],
    backgroundColor: HexColor(json["backgroundColor"]),
    url: json["url"],
    imageUrl: json["imageUrl"],
  );

  static List<IBanner> fromJsonList(dynamic json) => json != null ? (json as List<dynamic>).map((x) => IBanner.fromJson(x)).toList() : [];
}