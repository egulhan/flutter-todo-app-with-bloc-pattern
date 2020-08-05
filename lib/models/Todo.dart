class Todo {
  int id;
  String name;
  bool isDone;

  Todo({
    this.id,
    this.name,
    this.isDone,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'isDone': this.isDone,
      };

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Todo && o.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
