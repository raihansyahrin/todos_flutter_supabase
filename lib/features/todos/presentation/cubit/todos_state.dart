import 'package:equatable/equatable.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object?> get props => [];
}

class TodosInitial extends TodosState {}

class TodosLoading extends TodosState {}

class TodosSuccess extends TodosState {
  final String message;

  const TodosSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TodosLoaded extends TodosState {
  final Stream<List<Todos>> todos;

  const TodosLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

class TodosFailure extends TodosState {
  final String error;

  const TodosFailure(this.error);

  @override
  List<Object?> get props => [error];
}
