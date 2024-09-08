import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

class HomePage extends StatefulWidget {
  //const HomePage({super.key});
  HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight;
  String? _newTask;
  Box? _box;
  _HomePageState();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    //_deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _taskView(),
      floatingActionButton: _addTask(),
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        title: const Text(
          "Taskly",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
        future: Hive.openBox("tasks"),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            _box = _snapshot.data;
            return _taskList();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        var task = Task.fromMaP(tasks[_index]);
        return ListTile(
          onTap: () {
            task.done = !task.done;
            _box!.putAt(_index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(_index);
            setState(() {});
          },
          title: Text(
            task.content,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(task.timeStamp.toString()),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            color: Colors.red,
          ),
        );
      },
    );
  }

  Widget _addTask() {
    return FloatingActionButton(
      onPressed: _displayPopUp,
      child: const Icon(Icons.add),
    );
  }

  void _displayPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text("Add New Task"),
            content: TextField(
              onSubmitted: (_value) {
                if (_newTask != null) {
                  var _task = Task(
                      content: _newTask!,
                      done: false,
                      timeStamp: DateTime.now());
                  _box!.add(_task.toMap());
                }
                setState(() {
                  _newTask = null;
                  Navigator.pop(context);
                });
              },
              onChanged: (_value) {
                setState(() {
                  _newTask = _value;
                });
              },
            ),
          );
        });
  }
}
