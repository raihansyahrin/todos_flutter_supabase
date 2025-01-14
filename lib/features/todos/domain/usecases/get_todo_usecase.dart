import 'package:dartz/dartz.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';
import 'package:todos_supabase/features/todos/domain/repository/todos_repository.dart';

class GetTodoUsecase {
  final TodosRepository todosRepository;

  GetTodoUsecase(this.todosRepository);

  Either<String, Stream<List<Todos>>> execute() {
    return todosRepository.getTodos();
  }
}
