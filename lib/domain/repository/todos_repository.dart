import 'package:dartz/dartz.dart';
import 'package:todos_supabase/domain/entity/todos.dart';

abstract class TodosRepository {
  Future<Either<String, String>> createTodo(Todos todos);
  Either<String, Stream<List<Todos>>> getTodos();
}
