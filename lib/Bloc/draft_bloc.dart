import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_editor/Model/draft.dart';
import 'package:hive/hive.dart';

// Emit drafts

class DraftsCubit extends Cubit<List<Draft>> {
  DraftsCubit() : super([]);

  addDraft(Draft draft) async {
    var box = await Hive.openBox<Draft>('draft');
    box.add(draft);
    getDrafts();
  }

  updateDraft(int index, Draft draft) {
    final box = Hive.box<Draft>('draft');
    box.putAt(index, draft);
    getDrafts();
  }

  getDrafts() async {
    final box = await Hive.openBox<Draft>('draft');
    final drafts = box.values.toList();
    emit(drafts);
  }
}
