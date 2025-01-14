import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todos_supabase/data/data_sources/remote/remote_data_sources.dart';
import 'package:todos_supabase/data/models/todos_model.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late RemoteDataSourcesImpl dataSource;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    dataSource = RemoteDataSourcesImpl(mockSupabaseClient);
  });

  group('getTodo', () {
    test('should return a stream of TodosModel when query succeeds', () async {
      // Arrange
      when(() => mockSupabaseClient.from('todos')).thenReturn(mockQueryBuilder);

      final mockData = [
        {'id': 1, 'name': 'Task 1', 'isCompleted': false},
        {'id': 2, 'name': 'Task 2', 'isCompleted': true},
      ];

      when(() => mockQueryBuilder.stream(primaryKey: any(named: 'primaryKey')));
      // .thenAnswer(
      //     (_) => Stream.value(mockData as List<Map<String, dynamic>>));

      // Act
      final result = dataSource.getTodo();

      // Assert
      result.fold(
        (error) => fail('Should not return an error'),
        (stream) async {
          final todosList = await stream.first;
          expect(todosList, isA<List<TodosModel>>());
          expect(todosList.first.name, 'Task 1');
          expect(todosList.first.isCompleted, false);
        },
      );
    });

    test('should return an error when query fails', () async {
      // Arrange
      when(() => mockSupabaseClient.from('todos')).thenReturn(mockQueryBuilder);

      when(() => mockQueryBuilder.stream(primaryKey: any(named: 'primaryKey')))
          .thenThrow(Exception('Stream error'));

      // Act
      final result = dataSource.getTodo();

      // Assert
      result.fold(
        (error) => expect(error, 'Error Exception: Stream error'),
        (_) => fail('Should return an error'),
      );
    });
  });
}
