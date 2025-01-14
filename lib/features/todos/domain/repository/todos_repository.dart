import 'package:dartz/dartz.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';

abstract class TodosRepository {
  Future<Either<String, String>> createTodo(Todos todos);
  Either<String, Stream<List<Todos>>> getTodos();
  Future<Either<String, String>> updateTodo(Todos oldTodos, Todos newTodos);
  Future<Either<String, String>> delete(Todos todos);
}
