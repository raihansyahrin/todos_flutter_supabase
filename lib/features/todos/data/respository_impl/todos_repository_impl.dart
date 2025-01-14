import 'package:dartz/dartz.dart';
import 'package:todos_supabase/features/todos/data/data_sources/remote/remote_data_sources.dart';
import 'package:todos_supabase/features/todos/data/models/todos_model.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';
import 'package:todos_supabase/features/todos/domain/repository/todos_repository.dart';

class TodosRepositoryImpl extends TodosRepository {
  final RemoteDataSourcesImpl remoteDataSourcesImpl;
  TodosRepositoryImpl(this.remoteDataSourcesImpl);

  @override
  Future<Either<String, String>> createTodo(Todos todos) async {
    try {
      final todosModel = TodosModel.fromEntity(todos);
      await remoteDataSourcesImpl.createTodo(todosModel);
      return Right('Success');
    } catch (e) {
      return Left('Error $e');
    }
  }

  @override
  Either<String, Stream<List<TodosModel>>> getTodos() {
    try {
      return remoteDataSourcesImpl.getTodo();
    } catch (e) {
      return Left('Error $e');
    }
  }

  @override
  Future<Either<String, String>> updateTodo(
    Todos oldTodos,
    Todos newTodos,
  ) async {
    try {
      final oldTodo = TodosModel.fromEntity(oldTodos);
      final newTodo = TodosModel.fromEntity(newTodos);
      await remoteDataSourcesImpl.updateTodo(oldTodo, newTodo);
      return Right('Success Update');
    } catch (e) {
      return Right(e.toString());
    }
  }

  @override
  Future<Either<String, String>> delete(Todos todos) async {
    try {
      final todosModel = TodosModel.fromEntity(todos);

      await remoteDataSourcesImpl.deleteTodo(todosModel);
      return Right('Success Delete');
    } catch (e) {
      return Left('Error $e');
    }
  }
}
