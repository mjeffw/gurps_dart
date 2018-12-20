import 'package:json_annotation/json_annotation.dart';

part 'modifier.g.dart';

@JsonSerializable()
class Modifier {
  final String name;

  Modifier({this.name});

  static Modifier fetch(String name) {
    return Modifier(name: name);
  }
}
