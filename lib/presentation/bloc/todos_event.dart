import 'package:equatable/equatable.dart';
import 'package:todos_supabase/domain/entity/todos.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object?> get props => [];
}

class CreateTodoEvent extends TodosEvent {
  final Todos todos;

  const CreateTodoEvent(this.todos);

  @override
  List<Object?> get props => [todos];
}

class GetTodosEvent extends TodosEvent {}
