import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'modifier.g.dart';

@JsonSerializable()
class Modifier {
  Modifier({this.name});

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);

  final String name;

  static Map<String, Modifier> _modifiers = {};

  static Future<Modifier> fetch(String name) async {
    if (_modifiers.isEmpty) {
      var list = await fetchAll();
      for (Modifier m in list) {
        _modifiers[m.name] = m;
      }
    }
    return _modifiers[name];
  }

  static Future<List<Modifier>> fetchAll() async {
    String rawJson = await File('assets/data/modifiers.json').readAsString();
    List<Modifier> list = [];
    final Map<String, dynamic> itemMap = json.decode(rawJson);
    for (var jsonItem in itemMap['modifiers']) {
      list.add(Modifier.fromJson(jsonItem as Map<String, dynamic>));
    }
    return list;
  }
}
