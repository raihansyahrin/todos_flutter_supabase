import 'package:dartz/dartz.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';
import 'package:todos_supabase/features/todos/domain/repository/todos_repository.dart';

class UpdateTodoUsecase {
  final TodosRepository todosRepository;

  UpdateTodoUsecase(this.todosRepository);

  Future<Either<String, String>> execute(
    Todos oldTodos,
    Todos newTodos,
  ) async {
    return await todosRepository.updateTodo(
      oldTodos,
      newTodos,
    );
  }
}
