import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';
import 'package:todos_supabase/features/todos/domain/usecases/create_todo_usecase.dart';
import 'package:todos_supabase/features/todos/domain/usecases/delete_todo_usecase.dart';
import 'package:todos_supabase/features/todos/domain/usecases/get_todo_usecase.dart';
import 'package:todos_supabase/features/todos/domain/usecases/update_todo_usecase.dart';
import 'package:todos_supabase/features/todos/presentation/cubit/todos_state.dart';

class TodosCubit extends Cubit<TodosState> {
  CreateTodoUsecase createTodoUsecase;
  GetTodoUsecase getTodoUsecase;
  UpdateTodoUsecase updateTodoUsecase;
  DeleteTodoUsecase deleteTodoUsecase;
  final TextEditingController textEditingController = TextEditingController();
  bool isToggleCompleted = false;

  TodosCubit({
    required this.createTodoUsecase,
    required this.getTodoUsecase,
    required this.updateTodoUsecase,
    required this.deleteTodoUsecase,
  }) : super(TodosInitial());

  void getTodos() {
    emit(TodosLoading());
    final result = getTodoUsecase.execute();
    result.fold(
      (failure) => emit(TodosFailure(failure)),
      (success) => emit(TodosLoaded(success)),
    );
  }

  void createTodos(Todos todos) async {
    final result = await createTodoUsecase.execute(todos);
    result.fold(
      (failure) => emit(TodosFailure(failure)),
      (success) => log(success),
    );
  }

  void toggleCompleted() {
    isToggleCompleted = !isToggleCompleted;
  }

  void updateTodo(
    Todos oldTodos,
    bool isFinished,
  ) async {
    // emit(TodosLoading());\p\

    try {
      if (!isFinished) {
        final Either<String, String> data = await updateTodoUsecase.execute(
            oldTodos,
            Todos(
              id: oldTodos.id,
              name: textEditingController.text,
              isCompleted: oldTodos.isCompleted,
            ));
        return data.fold(
          (l) {
            log('bapak kiri');
            emit(TodosFailure(l));
          },
          (r) {
            log(r);
          },
        );
      } else {
        toggleCompleted();
        final Either<String, String> data = await updateTodoUsecase.execute(
            oldTodos,
            Todos(
              id: oldTodos.id,
              name: oldTodos.name,
              isCompleted: isToggleCompleted,
            ));
        return data.fold(
          (l) {
            emit(TodosFailure(l));
          },
          (r) {
            log(r);
          },
        );
      }
    } catch (e) {
      return emit(TodosFailure(e.toString()));
    }
  }

  void deleteTodo(Todos todos) async {
    // emit(TodosLoading());
    try {
      final Either<String, String> data =
          await deleteTodoUsecase.execute(todos);
      return data.fold(
        (l) {
          emit(TodosFailure(l));
        },
        (r) {
          log(r);
        },
      );
    } catch (e) {
      return emit(TodosFailure(e.toString()));
    }
  }
}
