import 'dart:ui';

// Sticker model with image path

class Sticker {
  String path;
  Offset offset;
  Sticker(this.path, {this.offset = const Offset(0, 0)});
}
