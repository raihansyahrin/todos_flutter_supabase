class TodosModel {
  final int? id;
  final String name;
  final bool isCompleted;

  TodosModel({
    this.id,
    required this.name,
    required this.isCompleted,
  });

/*
  fromMap (dari Map <--> Todos)
  {
    "id": 1,
    "name": "Laundry",
    "isCompleted": false;
  }
*/
  factory TodosModel.fromMap(Map<String, dynamic> json) {
    return TodosModel(
      id: json['id'] as int,
      name: json['name'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  /*
  toMap (dari note <--> Map)

  */

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
    };
  }
}
