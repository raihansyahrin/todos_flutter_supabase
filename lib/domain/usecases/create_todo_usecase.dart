import 'package:dartz/dartz.dart';
import 'package:todos_supabase/domain/entity/todos.dart';
import 'package:todos_supabase/domain/repository/todos_repository.dart';

class CreateTodoUsecase {
  final TodosRepository todosRepository;

  CreateTodoUsecase(this.todosRepository);

  Future<Either<String, String>> execute(Todos todos) async {
    return await todosRepository.createTodo(todos);
  }
}
