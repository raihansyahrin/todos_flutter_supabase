import 'package:dartz/dartz.dart';
import 'package:todos_supabase/data/data_sources/remote/remote_data_sources.dart';
import 'package:todos_supabase/data/models/todos_model.dart';
import 'package:todos_supabase/domain/entity/todos.dart';
import 'package:todos_supabase/domain/repository/todos_repository.dart';

class TodosRepositoryImpl extends TodosRepository {
  final RemoteDataSourcesImpl remoteDataSourcesImpl;
  TodosRepositoryImpl(this.remoteDataSourcesImpl);

  @override
  Future<Either<String, String>> createTodo(Todos todos) async {
    try {
      final todosModel = TodosModel(
        name: todos.name,
        isCompleted: todos.isCompleted,
      );

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
}
