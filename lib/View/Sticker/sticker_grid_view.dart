import 'package:flutter/material.dart';
import 'package:photo_editor/Model/sticker.dart';
import 'package:photo_editor/View/Sticker/sticker_view_cell.dart';

class StickersGridView extends StatelessWidget {
  final List<Sticker> stickers;
  final void Function(Sticker) handledidSelectSticker;

  StickersGridView(this.stickers, this.handledidSelectSticker);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(stickers.length, (index) {
        return Padding(
            padding: EdgeInsets.all(30),
            child: InkWell(
              child: StickerViewCell(stickers[index]),
              onTap: () {
                handledidSelectSticker(stickers[index]);
                Navigator.of(context).pop();
              },
            ));
      }),
    );
  }
}
