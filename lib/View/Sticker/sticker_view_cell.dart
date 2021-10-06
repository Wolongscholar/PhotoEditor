import 'package:flutter/material.dart';
import 'package:photo_editor/Model/sticker.dart';

// A cell of Sticker grid view

@immutable
class StickerViewCell extends StatelessWidget {
  final Sticker sticker;
  StickerViewCell(this.sticker);

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage(sticker.path), height: 100, width: 100);
  }
}
