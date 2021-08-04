import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../client/shared_prefs_client.dart';
import '../entity/todo.dart';

final todoRepository =
    Provider.autoDispose<TodoRepository>((ref) => TodoRepositoryImpl(ref.read));

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> saveTodos(List<Todo> todos);
}

class TodoRepositoryImpl implements TodoRepository {
  final Reader read;
  TodoRepositoryImpl(this.read);

  final _todoKey = 'todos';
  Future<List<Todo>> getTodos() async {
    final SharedPreferencesClient prefs = read(sharedPreferencesClient);
    final List<Map<String, dynamic>> todosJsons =
        await prefs.getJsonList(_todoKey);

    return todosJsons.map((json) => Todo.fromJson(json)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final SharedPreferencesClient prefs = read(sharedPreferencesClient);
    await prefs.saveJson(_todoKey, todos.map((todo) => todo.toJson()).toList());
  }
}
