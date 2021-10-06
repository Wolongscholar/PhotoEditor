import 'package:flutter/material.dart';
import 'package:photo_editor/Model/draft.dart';
import 'package:photo_editor/Screen/photo_edit_screen.dart';
import 'package:photo_editor/View/Draft/draft_view_cell.dart';

// Grid view of drafts

class DraftGridView extends StatelessWidget {
  final List<Draft> drafts;
  DraftGridView(this.drafts);

  @override
  Widget build(BuildContext context) {
    return drafts.isEmpty
        ? Center(child: Text("You have no photos!"))
        : GridView.count(
            crossAxisCount: 3,
            children: List.generate(drafts.length, (index) {
              return Center(
                  child: InkWell(
                child: DraftViewCell(drafts[index]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              PhotoEditScreen(draft: drafts[index])));
                },
              ));
            }),
          );
  }
}
