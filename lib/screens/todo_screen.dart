import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_with_bloc/bloc/todo_bloc.dart';
import 'package:todo_app_with_bloc/models/Todo.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  ScaffoldState _scaffold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-do'),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.add),
            onPressed: () {
              _scaffold.showBottomSheet<void>((BuildContext context) {
                return TodoAddForm();
              });
            },
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          _scaffold = Scaffold.of(context);

          return BlocConsumer<TodoBloc, TodoState>(
            listener: (context, state) {
              if (state is TodoError) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is TodoInitial) {
                return _buildInitial();
              } else if (state is TodosLoading) {
                return _buildLoading();
              } else if (state is TodosLoaded) {
                return _buildTodoList(state.todos);
              } else if (state is TodoAdding) {
                return _buildLoading();
              } else if (state is TodoAdded) {
                return _appendTodoToList(state.todos);
              } else if (state is TodoStatusChanging) {
                return _buildLoading();
              } else if (state is TodoStatusChanged) {
                return _buildTodoList(state.todos);
              } else {
                return _buildInitial();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildInitial() {
    return Container(child: Text('Initial'));
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildTodoList(List<Todo> todos) {
    if (todos.length == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('No to-do items'),
          ],
        ),
      );
    }

    return TodoList(todos);
  }

  Widget _appendTodoToList(List<Todo> todos) {
    return _buildTodoList(todos);
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final todoBloc = context.bloc<TodoBloc>();
      todoBloc.add(GetTodos());
    });
  }
}

class TodoAddForm extends StatelessWidget {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      color: Color(0xFFCCCCCC),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onSubmitted: (value) => _addTodo(context, value),
            controller: _textEditingController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Enter a name",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  color: Colors.redAccent,
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FlatButton(
                  color: Colors.green,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    String val = _textEditingController.text;
                    if (val.length > 0) {
                      _addTodo(context, val);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _addTodo(BuildContext context, String name) {
    final bloc = context.bloc<TodoBloc>();
    bloc.add(AddTodo(name));
  }
}

class TodoList extends StatelessWidget {
  final List<Todo> todos;

  TodoList(this.todos);

  @override
  Widget build(BuildContext context) {
    final todoBloc = BlocProvider.of<TodoBloc>(context);

    return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          Todo todo = todos[index];
          TextDecoration todoTextDecoration =
              todo.isDone ? TextDecoration.lineThrough : TextDecoration.none;

          return InkWell(
            onTap: () {
              bool isDone = !todo.isDone;
              todoBloc.add(ChangeTodoStatus(todo, isDone));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              child: Text(
                todo.name,
                style: TextStyle(decoration: todoTextDecoration),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                border: Border(bottom: BorderSide(color: Colors.grey.shade50)),
              ),
            ),
          );
        });
  }
}
