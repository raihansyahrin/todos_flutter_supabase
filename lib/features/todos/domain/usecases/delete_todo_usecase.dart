import 'package:dartz/dartz.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';
import 'package:todos_supabase/features/todos/domain/repository/todos_repository.dart';

class DeleteTodoUsecase {
  final TodosRepository todosRepository;

  DeleteTodoUsecase(this.todosRepository);

  Future<Either<String, String>> execute(Todos todos) async {
    return await todosRepository.delete(todos);
  }
}
