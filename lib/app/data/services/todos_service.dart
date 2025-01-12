import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todos_supabase/app/data/models/todos_model.dart';

class TodosService {
  final todosDatabase = Supabase.instance.client.from('todos');

  //Create
  Future createTodo(TodosModel todos) async {
    await todosDatabase.insert(todos.toMap());
  }

  //Read
  Stream<List> getTodo() {
    return Supabase.instance.client
        .from('todos')
        .stream(primaryKey: ['id']).map((data) => data
            .map(
              (todosMap) => TodosModel.fromMap(todosMap),
            )
            .toList());
  }

  //Update Todos
  Future updateTodo(TodosModel oldTodo, TodosModel newTodo) async {
    await todosDatabase.update({
      'name': newTodo.name,
      'isCompleted': newTodo.isCompleted,
    }).eq('id', oldTodo.id!);
  }
  // Future updateTodo(TodosModel oldTodo, String newName) async {
  //   await todosDatabase.update({'name': newName, 'isCompleted': isCompleted}).eq('id', oldTodo.id!);
  // }

  //Update Completed
  Future updateTodoCompleted(TodosModel todo, bool isCompleted) async {
    await todosDatabase.update(
      {'isCompleted': isCompleted},
    );
  }

  //Delete
  Future deleteTodo(TodosModel todo) async {
    await todosDatabase.delete().eq('id', todo.id!);
  }
}
