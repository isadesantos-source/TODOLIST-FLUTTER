import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class ToDoListPage extends StatefulWidget {
  final DateTime selectedDate;

  ToDoListPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  DatabaseReference database = FirebaseDatabase.instance.ref();
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(16, 80, 79, 79),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Lista de Tarefas    ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.black26,
                  textColor: Colors.white,
                  title: Text(
                    tasks[index].name,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: tasks[index].isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Icon(
                    tasks[index].isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: tasks[index].isCompleted
                        ? const Color.fromARGB(255, 67, 33, 126)
                        : const Color.fromARGB(255, 67, 33, 126),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          _toggleTaskCompletion(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeTask(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAddTaskDialog(context);
                  },
                  child: Text('Adicionar tarefa'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showRemoveAllTaskDialog(context);
                  },
                  child: Text('Remover todas'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String newTaskName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar tarefa'),
          content: TextField(
            onChanged: (value) {
              newTaskName = value;
            },
            decoration: InputDecoration(hintText: 'Nome da tarefa'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (newTaskName != "") {
                  var date =
                      '${widget.selectedDate.day}${widget.selectedDate.month}${widget.selectedDate.year}';
                  DatabaseReference newTaskRef = database
                      .child('calendar/$date/')
                      .push();
                  Task newTask = Task(name: newTaskName);
                  newTask.setIdFirebase(newTaskRef.key!);
                  newTaskRef.set(newTask.toJson());
                }
                Navigator.pop(context);
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveAllTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover todas as tarefas'),
          content: Text('Tem certeza que deseja remover todas as tarefas?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.clear();
                });
                Navigator.pop(context);
              },
              child: Text('Remover todas'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTaskCompletion(int index) {
    var date =
        '${widget.selectedDate.day}${widget.selectedDate.month}${widget.selectedDate.year}';
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      _sortTask();
    });
    database.child('calendar/$date/${tasks[index].idFirebase!}').update({
      'isCompleted': tasks[index].isCompleted,
    });
  }

  void _removeTask(int index) {
    var date =
        '${widget.selectedDate.day}${widget.selectedDate.month}${widget.selectedDate.year}';
    database.child('calendar/$date/${tasks[index].idFirebase!}').remove();
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _sortTask() {
    tasks.sort((a, b) {
      if (a.isCompleted == b.isCompleted) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return a.isCompleted ? 1 : -1;
    });
  }

  void _loadTasks() {
    var date =
        '${widget.selectedDate.day}${widget.selectedDate.month}${widget.selectedDate.year}';

    database.child('calendar/$date').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == null) {
        setState(() {
          tasks = [];
        });
        return;
      }
      Map map = data as Map;
      List<Task> loadedTasks = [];
      map.forEach((key, value) {
        Task task = Task(
          name: value['name'],
          isCompleted: value['isCompleted'] ?? false,
          idFirebase: key,
        );
        loadedTasks.add(task);
      });
      setState(() {
        tasks = loadedTasks;
        _sortTask();
      });
    });
  }
}

class Task {
  String name;
  bool isCompleted;
  String? idFirebase;

  Task({required this.name, this.isCompleted = false, this.idFirebase});

  void setIdFirebase(String id) {
    idFirebase = id;
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'isCompleted': isCompleted};
  }
}