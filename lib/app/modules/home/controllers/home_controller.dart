import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos_supabase/app/data/models/todos_model.dart';
import 'package:todos_supabase/app/data/services/todos_service.dart';
import 'package:todos_supabase/app/utils/widgets/custom_dialog.dart';

class HomeController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final todosService = TodosService();

  bool isCompleted = false;

  void toggleCompleted() {
    isCompleted = !isCompleted;

    update();
  }

  Future<void> createTodo() async {
    CustomDialog.show(
      controller: textController,
      onPressed: () {
        todosService.createTodo(
          TodosModel(name: textController.text, isCompleted: false),
        );
        textController.clear();
        Get.back();
      },
    );
  }

  Future<void> updateTodo(
      TodosModel oldTodo, TodosModel newTodo, bool isToggleCompleted) async {
    textController.text = oldTodo.name;

    if (isToggleCompleted) {
      toggleCompleted();
      todosService.updateTodo(
          oldTodo,
          TodosModel(
            name: textController.text,
            isCompleted: isCompleted,
          ));
      textController.clear();
    } else {
      CustomDialog.show(
        title: 'Edit Todo',
        controller: textController,
        onPressed: () {
          todosService.updateTodo(
              oldTodo,
              TodosModel(
                name: textController.text,
                isCompleted: oldTodo.isCompleted,
              ));
          textController.clear();

          Get.back();
        },
      );
    }
  }

  Future<void> deleteTodo(TodosModel todo) async {
    todosService.deleteTodo(todo);
  }
}
