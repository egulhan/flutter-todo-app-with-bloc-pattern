part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class GetTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String name;

  AddTodo(this.name);
}

class ChangeTodoStatus extends TodoEvent {
  final Todo todo;
  final bool isDone;

  ChangeTodoStatus(this.todo, this.isDone);
}
