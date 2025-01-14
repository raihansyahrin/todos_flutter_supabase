import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:todos_supabase/domain/entity/todos.dart';
import 'package:todos_supabase/domain/usecases/create_todo_usecase.dart';
import 'package:todos_supabase/domain/usecases/get_todo_usecase.dart';

import 'todos_event.dart';
import 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final CreateTodoUsecase createTodoUsecase;
  final GetTodoUsecase getTodoUsecase;

  TodosBloc({
    required this.createTodoUsecase,
    required this.getTodoUsecase,
  }) : super(TodosInitial()) {
    on<CreateTodoEvent>(_onCreateTodo);
    on<GetTodosEvent>(_onGetTodos);
  }

  // Handle creating a Todo
  Future<void> _onCreateTodo(
    CreateTodoEvent event,
    Emitter<TodosState> emit,
  ) async {
    emit(TodosLoading());
    final Either<String, String> result =
        await createTodoUsecase.execute(event.todos);

    result.fold(
      (failure) => emit(TodosFailure(failure)),
      (success) {
        emit(TodosSuccess(success));
        add(GetTodosEvent());
      },
    );
  }

  // Handle fetching the list of Todos
  Future<void> _onGetTodos(
    GetTodosEvent event,
    Emitter<TodosState> emit,
  ) async {
    emit(TodosLoading());
    final Either<String, Stream<List<Todos>>> result = getTodoUsecase.execute();

    await result.fold(
      (failure) async => emit(TodosFailure(failure)),
      (successFuture) async {
        try {
          final todos = successFuture; // Tunggu hingga future selesai
          emit(TodosLoaded(todos)); // Emit state dengan data
        } catch (e) {
          emit(TodosFailure('Error loading todos: $e'));
        }
      },
    );
  }
}
