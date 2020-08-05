import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app_with_bloc/data/todo_repository.dart';
import 'package:todo_app_with_bloc/models/Todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc(this.todoRepository) : super(TodoInitial());

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
//    try {
    if (event is GetTodos) {
      yield TodosLoading();
      List<Todo> todos = await todoRepository.getTodos();
      yield TodosLoaded(todos);
    } else if (event is AddTodo) {
      yield TodoAdding();
      List<Todo> todos = await todoRepository.addTodo(event.name);
      yield TodoAdded(todos);
    } else if (event is ChangeTodoStatus) {
      yield TodoStatusChanging();
      List<Todo> todos =
          await todoRepository.changeTodoStatus(event.todo, event.isDone);
      yield TodoStatusChanged(todos);
    }
//    }
//    catch (e) {
//      print(e);
//      yield TodoError('An unknown error occurred');
//    }
  }
}
