import 'package:flutter/material.dart';

class City {
  final String name, title, description;
  final Color color;

  City({
    required this.name,
    required this.title,
    required this.description,
    required this.color,
  });
}

class DemoData {
  final List<City> _cities = [
    City(
      name: 'Pisa',
      title: 'Pisa, Italy',
      description: 'Discover a beautiful city where ancient and modern meet',
      color: const Color(0xffdee5cf),
    ),
    City(
      name: 'Budapest',
      title: 'Budapest, Hungary',
      description: 'Meet the city with rich history and indescribable culture',
      color: const Color(0xffdaf3f7),
    ),
    City(
      name: 'London',
      title: 'London, England',
      description:
          'A diverse and exciting city with the world’s best sights and attractions!',
      color: const Color(0xfff9d9e2),
    ),
  ];
  List<City> get getCities => _cities;
}
