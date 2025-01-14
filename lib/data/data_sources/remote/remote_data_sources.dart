import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todos_supabase/data/models/todos_model.dart';

abstract class RemoteDataSources {
  Future<Either<String, String>> createTodo(TodosModel todo);
  Either<String, Stream<List<TodosModel>>> getTodo();
}

class RemoteDataSourcesImpl extends RemoteDataSources {
  final SupabaseClient supabaseClient;
  RemoteDataSourcesImpl(this.supabaseClient);

  @override
  Future<Either<String, String>> createTodo(TodosModel todo) async {
    final supabase = supabaseClient.from('todos');

    try {
      await supabase.insert(todo);
      return Right('Success');
    } catch (e) {
      return Left('Error $e');
    }
  }

  @override
  Either<String, Stream<List<TodosModel>>> getTodo() {
    try {
      final stream = supabaseClient.from('todos').stream(
        primaryKey: ['id'],
      ).map(
        (data) => data.map((todos) => TodosModel.fromJson(todos)).toList(),
      );

      return Right(stream);
    } catch (e) {
      return Left('Error: $e');
    }
  }
}
