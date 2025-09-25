import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/bloc/auth/auth_cubit.dart';
import 'package:tourist_app/bloc/todos/todos_cubit.dart';
import 'package:tourist_app/models/todo.dart';
import 'package:tourist_app/repositories/todo_repository.dart';
import 'package:tourist_app/ui/widgets/loading_indicator.dart';
import 'package:uuid/uuid.dart';

class TodoScreen extends StatelessWidget {
  final String tripId;

  const TodoScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosCubit(TodoRepository(), tripId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
        ),
        body: BlocBuilder<TodosCubit, TodosState>(
          builder: (context, state) {
            if (state is TodosLoading) {
              return const LoadingIndicator();
            } else if (state is TodosLoaded) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  return CheckboxListTile(
                    title: Text(todo.task),
                    value: todo.isCompleted,
                    onChanged: (value) {
                      final updatedTodo = Todo(
                        id: todo.id,
                        userId: todo.userId,
                        tripId: todo.tripId,
                        task: todo.task,
                        isCompleted: value!,
                      );
                      context.read<TodosCubit>().updateTodo(updatedTodo);
                    },
                  );
                },
              );
            } else if (state is TodosError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No todos yet.'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Task'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final userId = context.read<AuthCubit>().client.auth.currentUser!.id;
                final todo = Todo(
                  id: const Uuid().v4(),
                  userId: userId,
                  tripId: tripId,
                  task: taskController.text,
                );
                context.read<TodosCubit>().addTodo(todo);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
