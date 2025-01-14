import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todos_supabase/features/todos/data/models/todos_model.dart';

abstract class RemoteDataSources {
  Future<Either<String, String>> createTodo(TodosModel todo);
  Either<String, Stream<List<TodosModel>>> getTodo();
  Future<Either<String, String>> updateTodo(
    TodosModel oldTodos,
    TodosModel newTodos,
  );
  Future<Either<String, String>> deleteTodo(TodosModel todo);
}

class RemoteDataSourcesImpl extends RemoteDataSources {
  final SupabaseClient supabaseClient;
  RemoteDataSourcesImpl(this.supabaseClient);

  @override
  Future<Either<String, String>> createTodo(TodosModel todo) async {
    try {
      await supabaseClient.from('todos').insert(todo.toJson());
      return Right('Success Add Data');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Either<String, Stream<List<TodosModel>>> getTodo() {
    final stream = supabaseClient
        .from('todos')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
          try {
            return data.map((todos) => TodosModel.fromJson(todos)).toList();
          } catch (e) {
            throw Exception('Error parsing data: ${e.toString()}');
          }
        });

    return Right(stream);
  }

  @override
  Future<Either<String, String>> updateTodo(
    TodosModel oldTodos,
    TodosModel newTodos,
  ) async {
    try {
      await supabaseClient.from('todos').update({
        'name': newTodos.name,
        'isCompleted': newTodos.isCompleted,
      }).eq('id', oldTodos.id!);

      return Right('Success Update');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> deleteTodo(TodosModel todo) async {
    try {
      await supabaseClient.from('todos').delete().eq('id', todo.id!);
      return Right('Success Delete');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
}
