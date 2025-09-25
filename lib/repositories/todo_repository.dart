import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourist_app/models/todo.dart';

class TodoRepository {
  final SupabaseClient client;

  TodoRepository({SupabaseClient? client}) : client = client ?? Supabase.instance.client;

  Future<List<Todo>> getTodos(String tripId) async {
    final data = await client
        .from('todos')
        .select()
        .eq('trip_id', tripId)
        .order('created_at', ascending: true);
    return (data as List).map((e) => Todo.fromMap(e)).toList();
  }

  Future<void> addTodo(Todo todo) async {
    await client.from('todos').insert(todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    await client.from('todos').update(todo.toMap()).eq('id', todo.id);
  }

  Future<void> deleteTodo(String todoId) async {
    await client.from('todos').delete().eq('id', todoId);
  }
}
