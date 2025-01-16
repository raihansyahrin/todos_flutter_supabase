import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';
import 'package:todos_supabase/features/todos/domain/usecases/create_todo_usecase.dart';
import 'package:todos_supabase/features/todos/domain/usecases/delete_todo_usecase.dart';
import 'package:todos_supabase/features/todos/domain/usecases/get_todo_usecase.dart';
import 'package:todos_supabase/features/todos/domain/usecases/update_todo_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todos_state.dart';
part 'todos_cubit.freezed.dart';

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
  }) : super(TodosState.initial());

  void getTodos() {
    final result = getTodoUsecase.execute();
    result.fold(
      (failure) => emit(TodosState.error(failure)),
      (success) => emit(TodosState.loaded(success)),
    );
  }

  void createTodos(Todos todos) async {
    final result = await createTodoUsecase.execute(todos);
    result.fold(
      (failure) => emit(TodosState.error(failure)),
      (success) => log(success),
    );
  }

  void toggleCompleted() {
    isToggleCompleted = !isToggleCompleted;
  }

  void updateTodo(
    Todos oldTodos,
    Todos newTodos,
    bool isFinished,
  ) async {
    // emit(TodosState.loading());

    try {
      if (!isFinished) {
        emit(state.copyWith(isLoading: true));
        print('before is loding ${state.isLoading}');
        await Future.delayed(Duration(seconds: 5));
        final Either<String, String> data = await updateTodoUsecase.execute(
          oldTodos,
          newTodos,
        );
        return data.fold(
          (l) {
            log(l);
            emit(TodosState.error(l));
          },
          (r) {
            log(r);
            // emit(TodosState.success(r));
            getTodos();
            emit(state.copyWith(isLoading: false));
            print('after is loding ${state.isLoading}');
          },
        );
      } else {
        toggleCompleted();
        final Either<String, String> data = await updateTodoUsecase.execute(
          oldTodos,
          newTodos,
        );
        return data.fold(
          (l) {
            emit(TodosState.error(l));
          },
          (r) {
            log(r);
          },
        );
      }
    } catch (e) {
      return emit(TodosState.error(e.toString()));
    } finally {
      textEditingController.clear();
    }
  }

  void deleteTodo(Todos todos) async {
    try {
      final Either<String, String> data =
          await deleteTodoUsecase.execute(todos);
      return data.fold(
        (l) {
          emit(TodosState.error(l));
        },
        (r) {
          log(r);
        },
      );
    } catch (e) {
      return emit(TodosState.error(e.toString()));
    }
  }
}
