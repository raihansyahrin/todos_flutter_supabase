import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todos_supabase/data/data_sources/remote/remote_data_sources.dart';
import 'package:todos_supabase/data/respository_impl/todos_repository_impl.dart';
import 'package:todos_supabase/domain/repository/todos_repository.dart';
import 'package:todos_supabase/domain/usecases/create_todo_usecase.dart';
import 'package:todos_supabase/domain/usecases/get_todo_usecase.dart';
import 'package:todos_supabase/presentation/bloc/todos_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final supabaseClient = Supabase.instance.client;

  // Daftarkan SupabaseClient
  sl.registerSingleton<SupabaseClient>(supabaseClient);

  sl.registerSingleton<RemoteDataSourcesImpl>(
    RemoteDataSourcesImpl(
      sl(),
    ),
  );

  sl.registerSingleton<TodosRepository>(
    TodosRepositoryImpl(sl()),
  );

  sl.registerSingleton<CreateTodoUsecase>(
    CreateTodoUsecase(sl()),
  );

  sl.registerSingleton<GetTodoUsecase>(
    GetTodoUsecase(sl()),
  );

  sl.registerFactory(
    () => TodosBloc(
      createTodoUsecase: sl(),
      getTodoUsecase: sl(),
    ),
  );
}
