import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:todos_supabase/dependency_injection.dart';
import 'package:todos_supabase/features/coba/login_page.dart';
import 'package:todos_supabase/features/coba/register_page.dart';
import 'package:todos_supabase/features/coba/splash_page.dart';
import 'package:todos_supabase/features/todos/presentation/cubit/todos_cubit.dart';
import 'package:todos_supabase/features/todos/presentation/pages/todos_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TodosCubit>()..getTodos(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todos App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const TodosPage(),
        initialRoute: '/splash',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/todos': (context) => const TodosPage(),
        },
      ),
    );
  }
}
