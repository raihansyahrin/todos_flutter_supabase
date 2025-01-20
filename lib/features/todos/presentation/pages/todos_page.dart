import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todos_supabase/features/todos/domain/entity/todos.dart';
import 'package:todos_supabase/features/todos/presentation/cubit/todos_cubit.dart';
import 'package:todos_supabase/main.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('rebuild body');
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos Cubit ${supabase.auth.currentUser?.email}'),
        actions: [
          IconButton(
            onPressed: () {
              supabase.auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<TodosCubit, TodosState>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(
              child: Text('Initial'),
            ),
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
            success: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
              return SizedBox.shrink();
            },
            loaded: (todos) {
              return StreamBuilder<List<Todos>>(
                stream: todos,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
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
                          // title: (state is TodosState.loading)
                          //     ? Container(
                          //         width: 100,
                          //         height: 20,
                          //         color: Colors.grey,
                          //       )
                          //     : Text(data.name),
                          title: Text(data.name),
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
                                      Todos(
                                        name: data.name,
                                        isCompleted: value!,
                                      ),
                                      true,
                                      // value!,
                                    );
                                    cubit.textEditingController.clear();
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final cubit =
                                            context.read<TodosCubit>();
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
                                                  Todos(
                                                    id: data.id,
                                                    name: cubit
                                                        .textEditingController
                                                        .text,
                                                    isCompleted:
                                                        data.isCompleted,
                                                  ),
                                                  false,
                                                );
                                                cubit.textEditingController
                                                    .clear();

                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Edit'),
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
            },
            error: (error) => Center(
              child: Text('Error: $error'),
            ),
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
