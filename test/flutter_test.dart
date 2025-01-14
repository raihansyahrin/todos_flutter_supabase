import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos_supabase/features/todos/data/data_sources/remote/remote_data_sources.dart';
import 'package:todos_supabase/features/todos/data/models/todos_model.dart';
import 'package:todos_supabase/features/todos/data/respository_impl/todos_repository_impl.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';

class MockRemoteDataSourcesImpl extends Mock implements RemoteDataSourcesImpl {}

void main() {
  late MockRemoteDataSourcesImpl mockRemoteDataSourcesImpl;
  late TodosRepositoryImpl todosRepositoryImpl;

  setUp(() {
    mockRemoteDataSourcesImpl = MockRemoteDataSourcesImpl();
    todosRepositoryImpl = TodosRepositoryImpl(mockRemoteDataSourcesImpl);
  });

  group('updateTodo', () {
    final oldTodo = Todos(id: 1, name: 'Old Todo', isCompleted: false);
    final newTodo = Todos(id: 1, name: 'Updated Todo', isCompleted: true);

    test('should return success when updateTodo is called with valid data',
        () async {
      // Arrange
      final oldTodoModel =
          TodosModel(name: oldTodo.name, isCompleted: oldTodo.isCompleted);
      final newTodoModel =
          TodosModel(name: newTodo.name, isCompleted: newTodo.isCompleted);

      // Mock the remote data source to return a successful response
      when(mockRemoteDataSourcesImpl.updateTodo(oldTodoModel, newTodoModel))
          .thenAnswer((_) async => Right('Success Update'));

      // Act
      final result = await todosRepositoryImpl.updateTodo(oldTodo, newTodo);

      // Assert
      expect(result, equals(Right('Success Update')));
      verify(mockRemoteDataSourcesImpl.updateTodo(oldTodoModel, newTodoModel))
          .called(1);
    });

    test('should return error when updateTodo throws an exception', () async {
      // Arrange
      final oldTodoModel =
          TodosModel(name: oldTodo.name, isCompleted: oldTodo.isCompleted);
      final newTodoModel =
          TodosModel(name: newTodo.name, isCompleted: newTodo.isCompleted);

      // Mock the remote data source to throw an exception
      when(mockRemoteDataSourcesImpl.updateTodo(oldTodoModel, newTodoModel))
          .thenThrow(Exception('Update failed'));

      // Act
      final result = await todosRepositoryImpl.updateTodo(oldTodo, newTodo);

      // Assert
      expect(result, equals(Left('Exception: Update failed')));
      verify(mockRemoteDataSourcesImpl.updateTodo(oldTodoModel, newTodoModel))
          .called(1);
    });
  });
}
