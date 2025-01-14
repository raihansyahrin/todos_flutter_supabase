import 'package:todos_supabase/features/todos/domain/entity/todos.dart';

class TodosModel extends Todos {
  const TodosModel({
    super.id,
    required super.name,
    required super.isCompleted,
  });

  factory TodosModel.fromJson(Map<String, dynamic> data) {
    return TodosModel(
      id: data['id'] as int,
      name: data['name'] as String,
      isCompleted: data['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "isCompleted": isCompleted,
    };
  }

  Todos toEntity() {
    return Todos(
      name: name,
      isCompleted: isCompleted,
    );
  }

  static TodosModel fromEntity(Todos todos) {
    return TodosModel(
      id: todos.id,
      name: todos.name,
      isCompleted: todos.isCompleted,
    );
  }
}
