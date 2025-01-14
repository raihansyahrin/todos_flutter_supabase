import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todos_supabase/injection.dart';
import 'package:todos_supabase/presentation/bloc/todos_bloc.dart';
import 'package:todos_supabase/presentation/pages/todos_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TodosBloc>(), // Registrasi TodosBloc
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todos App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodosPage(), // Memulai dengan layar TodosScreen
      ),
    );
  }
}
