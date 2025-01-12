import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:todos_supabase/app/data/models/todos_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: controller.todosService.getTodo(),
        builder: (context, snapshot) {
          //loading
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          //loaded
          final data = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              controller.todosService.getTodo();
            },
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final todo = data[index];
                return ListTile(
                    title: Text(todo.name),
                    trailing: SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: WidgetStateProperty.resolveWith(
                              (states) {
                                return null;
                              },
                            ),
                            value: todo.isCompleted,
                            shape: CircleBorder(),
                            onChanged: (bool? value) {
                              controller.updateTodo(
                                todo,
                                TodosModel(
                                  name: todo.name,
                                  isCompleted: controller.isCompleted,
                                ),
                                true,
                              );
                              // controller.toggleCompleted();
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              controller.updateTodo(
                                todo,
                                TodosModel(
                                  name: controller.textController.text,
                                  isCompleted: controller.isCompleted,
                                ),
                                false,
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.deleteTodo(todo);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.createTodo();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
