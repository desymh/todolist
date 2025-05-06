import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Map<String, dynamic>> _todos = [];
  final List<Map<String, dynamic>> _filteredTodos = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
    _searchController.addListener(_filterTodos);
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');

    if (todosString != null && todosString.isNotEmpty) {
      try {
        final List<dynamic> todosList = jsonDecode(todosString);
        setState(() {
          _todos.addAll(todosList.map((todo) => Map<String, dynamic>.from(todo)));
          _filteredTodos.addAll(todosList.map((todo) => Map<String, dynamic>.from(todo)));
        });
      } catch (e) {
        print("Error decoding todos: $e");
      }
    } else {
      setState(() {
        _todos.clear();
        _filteredTodos.clear();
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    if (_todos.isNotEmpty) {
      await prefs.setString('todos', jsonEncode(_todos));
    } else {
      await prefs.setString('todos', '[]');
    }
  }

  void _addTodo() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        _todos.add({
          'task': text,
          'isDone': false,
        });
        _controller.clear();
      });
      _saveTodos();
      _filterTodos();
    }
  }

  void _removeTodo(int filteredIndex) {
    final todo = _filteredTodos[filteredIndex];
    final originalIndex = _todos.indexOf(todo);
    setState(() {
      _todos.removeAt(originalIndex);
    });
    _saveTodos();
    _filterTodos();
  }

  void _toggleDone(int filteredIndex) {
    final todo = _filteredTodos[filteredIndex];
    final originalIndex = _todos.indexOf(todo);
    setState(() {
      _todos[originalIndex]['isDone'] = !_todos[originalIndex]['isDone'];
    });
    _saveTodos();
    _filterTodos();
  }

  void _editTodo(int filteredIndex) {
    final todo = _filteredTodos[filteredIndex];
    final originalIndex = _todos.indexOf(todo);
    _controller.text = todo['task'] ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Tugas'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Tugas',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _todos[originalIndex]['task'] = _controller.text;
                });
                _saveTodos();
                _controller.clear();
                Navigator.of(context).pop();
                _filterTodos();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _filterTodos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTodos
          ..clear()
          ..addAll(_todos);
      } else {
        _filteredTodos
          ..clear()
          ..addAll(_todos.where((todo) =>
              (todo['task'] ?? '').toString().toLowerCase().contains(query)));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pencarian
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari Tugas',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Menambah Tugas
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Tambahkan Tugas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _addTodo,
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.teal,
                  mini: true, // ✅ Tambah mini agar cocok dalam Row
                )
              ],
            ),
            const SizedBox(height: 16),
            // Daftar Tugas
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = _filteredTodos[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        todo['task'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          decoration: todo['isDone'] == true ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: todo['isDone'] == true,
                        onChanged: (bool? value) {
                          _toggleDone(index);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editTodo(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeTodo(index),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
