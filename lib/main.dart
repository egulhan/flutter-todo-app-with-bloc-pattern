import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_with_bloc/bloc/todo_bloc.dart';
import 'package:todo_app_with_bloc/data/todo_repository.dart';
import 'package:todo_app_with_bloc/screens/todo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-do App with BLoC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => TodoBloc(LocalTodoRepository()),
        child: TodoScreen(),
      ),
    );
  }
}
