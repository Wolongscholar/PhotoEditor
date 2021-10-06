import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_editor/Bloc/draft_bloc.dart';
import 'package:photo_editor/Model/draft.dart';
import 'package:photo_editor/View/Draft/draft_grid_view.dart';
import 'package:photo_editor/Screen/photo_edit_screen.dart';

// Home screen with saved draft grid view and edit new photo button

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<DraftsCubit>(context).getDrafts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Your photos")),
        body: SafeArea(
            child: Stack(children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 60,
              child: _buildDraftGridView()),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar())
        ])));
  }

  // Listen to draft provider to refresh grid view
  Widget _buildDraftGridView() {
    return BlocBuilder<DraftsCubit, List<Draft>>(
        builder: (context, drafts) => DraftGridView(drafts));
  }

  Widget _buildBottomBar() {
    return Container(
        height: 60,
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: TextButton.icon(
              icon: Icon(Icons.add),
              label: Text('New photo'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => PhotoEditScreen())),
            )));
  }
}
