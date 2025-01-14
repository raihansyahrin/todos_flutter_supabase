import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_supabase/domain/entity/todos.dart';
import 'package:todos_supabase/presentation/bloc/todos_bloc.dart';
import 'package:todos_supabase/presentation/bloc/todos_event.dart';
import 'package:todos_supabase/presentation/bloc/todos_state.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return BlocProvider(
      create: (_) => context.read<TodosBloc>()..add(GetTodosEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Todos')),
        body: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            log('rebuild body');
            if (state is TodosLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodosLoaded) {
              return StreamBuilder<List<Todos>>(
                  stream: state.todos,
                  builder: (context, snapshot) {
                    log('rebuild stream');
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final todosList = snapshot.data!;
                    return ListView.builder(
                      itemCount: todosList.length,
                      itemBuilder: (context, index) {
                        final todo = todosList[index];
                        return ListTile(
                          title: Text(todo.name),
                          subtitle:
                              Text(todo.isCompleted ? 'Completed' : 'Pending'),
                        );
                      },
                    );
                  });
            } else if (state is TodosFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: Text('No Todos Found'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTodoDialog(context, textController);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddTodoDialog(
      BuildContext context, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Todo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter todo name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final todoName = controller.text.trim();
                if (todoName.isNotEmpty) {
                  context.read<TodosBloc>().add(
                        CreateTodoEvent(
                          Todos(name: todoName, isCompleted: false),
                        ),
                      );
                  controller.clear();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
