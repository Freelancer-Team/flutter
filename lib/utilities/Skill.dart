import 'package:http/http.dart' as http;
import 'dart:convert';

class Category {
  int id;
  int name;
}

class Skill {
  String name;
  int id;
  Category category;
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <String>[]]);

  final String title;
  final List<String> children;
}
