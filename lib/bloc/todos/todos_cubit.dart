import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourist_app/models/todo.dart';
import 'package:tourist_app/repositories/todo_repository.dart';

part 'todos_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final TodoRepository _todoRepository;
  final String tripId;

  TodosCubit(this._todoRepository, this.tripId) : super(TodosInitial()) {
    fetchTodos();
  }

  void fetchTodos() async {
    try {
      emit(TodosLoading());
      final todos = await _todoRepository.getTodos(tripId);
      emit(TodosLoaded(todos));
    } catch (e) {
      emit(TodosError(e.toString()));
    }
  }

  void addTodo(Todo todo) async {
    try {
      await _todoRepository.addTodo(todo);
      fetchTodos();
    } catch (e) {
      emit(TodosError(e.toString()));
    }
  }

  void updateTodo(Todo todo) async {
    try {
      await _todoRepository.updateTodo(todo);
      fetchTodos();
    } catch (e) {
      emit(TodosError(e.toString()));
    }
  }

  void deleteTodo(String todoId) async {
    try {
      await _todoRepository.deleteTodo(todoId);
      fetchTodos();
    } catch (e) {
      emit(TodosError(e.toString()));
    }
  }
}
