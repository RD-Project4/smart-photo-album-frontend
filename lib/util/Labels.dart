import 'package:flutter/material.dart';

class SuperCategory {
  String name;
  IconData icon;
  List<String> labels;

  SuperCategory(this.name, this.icon, this.labels);
}

var superCategories = [
  SuperCategory("Landscape", Icons.landscape_outlined,
      ["Nature", "Buildings", "Snowscape", "Sea"]),
  SuperCategory("Animals", Icons.pets_outlined, ["Pet", "Sea life"]),
  SuperCategory("Character", Icons.person_outline, ["Group photo", "Selfie"]),
  SuperCategory("Food", Icons.food_bank_outlined, [])
];
