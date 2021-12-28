import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/food.dart';

class FoodProvider with ChangeNotifier {
  // Variable that caching the list of foods;
  List<Food> _foods = [];
  // Will contain an error message if service request gone wrong
  late String _errorMessage;

  // Loading state
  bool _isLoading = true;

  // Getter
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  //// Using UnmodifiableListView to prevent data for direct changes.
  //// Any data changes must go through the services method.
  UnmodifiableListView<Food> get foods => UnmodifiableListView(_foods);

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    // Clear the cache data to get the latest list of data.
    _foods.clear();
    await getFoods();
  }

  Future<void> getFoods() async {
    if (_foods.isEmpty) {
      _isLoading = true;
      // Request data to the server
      var result = await http.get(
        Uri.parse('https://mocki.io/v1/52c41978-6e31-4ea3-b917-01899e3ed373'),
      );

      // Check if the request successful
      if (result.statusCode == 200) {
        // Decode result body into a list of object (according to the json model).
        List data = jsonDecode(result.body);
        // Convert the data into a List of Food.
        List<Food> foods = data.map((item) => Food.fromJson(item)).toList();
        // Put the value into a _foods variable (Data Cacheted).
        _foods = foods;
      } else {
        // If the response code not 200 than it should be any Http Request error.
        // Because this is a simple app for now I'm just print the error.
        print(
            'ERROR SPACE PROVIDER: CODE ${result.statusCode} | BODY: ${result.body}');
        _errorMessage = result.body;
      }
      // Finishing the loading state and notify data changes.
      _isLoading = false;
      notifyListeners();
    }
  }

  // Find by ID use to bookmark button consumer.
  Food findById(int foodId) =>
      _foods.firstWhere((element) => element.id == foodId);

  // Function to toggle bookmark status
  bool bookmarkToggle(int foodId) {
    // Looking space in _items
    int index = _foods.indexWhere((element) => element.id == foodId);
    if (index > -1) {
      _foods[index].isBookmarked = !_foods[index].isBookmarked;
      notifyListeners();
      return _foods[index].isBookmarked;
    } else {
      print('TOGGLE FAVORITE: ID SPACE IS NOT FOUND');
      return false;
    }
  }
}
