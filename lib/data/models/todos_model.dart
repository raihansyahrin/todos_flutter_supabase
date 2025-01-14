import 'package:todos_supabase/domain/entity/todos.dart';

class TodosModel extends Todos {
  const TodosModel({
    required super.name,
    required super.isCompleted,
  });

  factory TodosModel.fromJson(Map<String, dynamic> data) {
    return TodosModel(
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
}
