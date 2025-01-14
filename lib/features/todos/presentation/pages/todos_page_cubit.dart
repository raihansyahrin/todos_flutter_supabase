import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';
import 'package:todos_supabase/features/todos/presentation/cubit/todos_cubit.dart';
import 'package:todos_supabase/features/todos/presentation/cubit/todos_state.dart';

class TodosPageCubit extends StatelessWidget {
  const TodosPageCubit({super.key});

  @override
  Widget build(BuildContext context) {
    log('rebuild body');
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos Cubit'),
      ),
      body: BlocConsumer<TodosCubit, TodosState>(
        listener: (context, state) {
          if (state is TodosSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TodosInitial) {
            return Center(
              child: Text('Initial'),
            );
          } else if (state is TodosLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TodosLoaded) {
            return StreamBuilder<List<Todos>>(
              stream: state.todos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Todos'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<TodosCubit>().getTodos();
                  },
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data![index];

                      return ListTile(
                        title: (state is TodosLoading ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData ||
                                snapshot.data!.isEmpty)
                            ? Container(
                                width: 100,
                                height: 20,
                                color: Colors.grey,
                              )
                            : Text(data.name),
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
                                value: data.isCompleted,
                                shape: CircleBorder(),
                                onChanged: (bool? value) {
                                  final cubit = context.read<TodosCubit>();
                                  cubit.updateTodo(
                                    data,
                                    value!,
                                  );
                                  cubit.textEditingController.clear();
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final cubit = context.read<TodosCubit>();
                                      cubit.textEditingController.text =
                                          data.name;
                                      return AlertDialog(
                                        title: const Text('Edit  Todo'),
                                        content: TextField(
                                          controller:
                                              cubit.textEditingController,
                                          decoration: const InputDecoration(
                                              hintText: 'Enter todo name'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              cubit.updateTodo(
                                                data,
                                                false,
                                              );
                                              cubit.textEditingController
                                                  .clear();

                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Add'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<TodosCubit>().deleteTodo(data);
                                },
                                icon: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is TodosFailure) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          }
          return Center(
            child: Text('Error'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final cubit = context.read<TodosCubit>();

              return AlertDialog(
                title: const Text('Add New Todo'),
                content: TextField(
                  controller: cubit.textEditingController,
                  decoration:
                      const InputDecoration(hintText: 'Enter todo name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final todoName = cubit.textEditingController.text;
                      if (todoName.isNotEmpty) {
                        cubit.createTodos(
                          Todos(
                            name: todoName,
                            isCompleted: false,
                          ),
                        );
                        cubit.textEditingController.clear();
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
