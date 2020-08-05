import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_with_bloc/models/Todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();

  Future<List<Todo>> addTodo(String name);

  Future<List<Todo>> changeTodoStatus(Todo todo, bool isDone);
}

class LocalTodoRepository extends TodoRepository {
  @override
  Future<List<Todo>> getTodos() async {
    List<Todo> todoList = [];

    SharedPreferences _sharedPref = await SharedPreferences.getInstance();
    String json = await _sharedPref.get('todos');

    if (json == null) {
      return todoList;
    }

    List<dynamic> todoListMap = jsonDecode(json);
    todoList = todoListMap.map((item) => Todo.fromJson(item)).toList();

    return todoList;
  }

  @override
  Future<List<Todo>> changeTodoStatus(Todo todo, bool isDone) async {
    todo.isDone = isDone;

    List<Todo> todos = await this.getTodos();
    int todoIndex = todos.indexWhere((item) => item.id == todo.id);

    todos[todoIndex] = todo;

    await this._setTodosToSharedPref(todos);

    return todos;
  }

  @override
  Future<List<Todo>> addTodo(String name) async {
    SharedPreferences _sharedPref = await SharedPreferences.getInstance();
    List<Todo> todos = await this.getTodos();
    Todo todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      isDone: false,
    );

    todos.add(todo);

    await this._setTodosToSharedPref(todos);

    return todos;
  }

  Future<void> _setTodosToSharedPref(List<Todo> todos) async {
    SharedPreferences _sharedPref = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> todoListMap =
        todos.map((item) => item.toJson()).toList();
    await _sharedPref.setString('todos', jsonEncode(todoListMap));
  }
}
