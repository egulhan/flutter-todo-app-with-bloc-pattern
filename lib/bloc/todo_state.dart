part of 'todo_bloc.dart';

@immutable
abstract class TodoState {
  const TodoState();
}

class TodoInitial extends TodoState {}

class TodosLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;

  TodosLoaded(this.todos);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodosLoaded && o.todos == todos;
  }

  @override
  int get hashCode => todos.hashCode;
}

class TodoAdding extends TodoState {}

class TodoAdded extends TodoState {
  final List<Todo> todos;

  TodoAdded(this.todos);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodoAdded && o.todos == todos;
  }

  @override
  int get hashCode => todos.hashCode;
}

class TodoStatusChanging extends TodoState {}

class TodoStatusChanged extends TodoState {
  final List<Todo> todos;

  TodoStatusChanged(this.todos);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodoStatusChanged && o.todos == todos;
  }

  @override
  int get hashCode => todos.hashCode;
}

class TodoError extends TodoState {
  final String message;

  TodoError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodoError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
