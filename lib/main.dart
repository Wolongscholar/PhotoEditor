import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_editor/Bloc/draft_bloc.dart';
import 'package:photo_editor/Model/Service/database_service.dart';
import 'package:photo_editor/Screen/home_screen.dart';
import 'package:photo_editor/View/theme.dart';

Future<void> main() async {
  // Setup database
  WidgetsFlutterBinding.ensureInitialized();
  DataBaseService.setUp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DraftsCubit(),
        child: MaterialApp(
          title: 'Photo Editor',
          theme: defaultTheme,
          home: HomeScreen(),
        ));
  }
}
