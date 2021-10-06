import 'package:flutter/material.dart';
import 'package:photo_editor/Model/sticker.dart';
import 'package:photo_editor/View/Sticker/sticker_grid_view.dart';

// Screen for selecting a sticker from list

class StickerSelectScreen extends StatelessWidget {
  final void Function(Sticker) handledidSelectSticker;

  final List<Sticker> stickers = List<String>.generate(
          12, (counter) => "assets/images/stickers/sticker${counter + 1}.png")
      .map((path) => Sticker(path))
      .toList();

  StickerSelectScreen(this.handledidSelectSticker);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text("Stickers"), backgroundColor: Colors.black),
        body: StickersGridView(stickers, handledidSelectSticker));
  }
}
