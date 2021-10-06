import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Provider to emit filter color

class FilterProvider extends ChangeNotifier {
  Color _color = Colors.white;

  Color get color => _color;

  setNewColor(Color color) async {
    _color = color;
    notifyListeners();
  }
}
