import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_editor/Model/draft.dart';

// A cell in draft grid view shows the saved draft's image

@immutable
class DraftViewCell extends StatelessWidget {
  final Draft draft;

  DraftViewCell(this.draft);

  @override
  Widget build(BuildContext context) {
    print(draft.path);
    return FutureBuilder<String>(
        future: absolutePathForImage(draft.path),
        builder: (context, snapshot) {
          final path = snapshot.data;
          if (path != null) {
            return Padding(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        color: Colors.grey,
                        child: Image(
                            fit: BoxFit.cover, image: FileImage(File(path))))));
          }
          return SizedBox.shrink();
        });
  }
}
