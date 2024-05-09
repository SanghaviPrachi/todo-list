// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main function to run the app
void main() {
  runApp(MyApp());
}

// Definition of a Task class
class Task {
  String name; // Name of the task
  bool isCompleted; // Completion status of the task

  // Constructor with an optional named parameter
  Task(this.name, {this.isCompleted = false});
}

// Definition of TaskList class which extends ChangeNotifier
class TaskList extends ChangeNotifier {
  List<Task> _tasks = []; // List to hold tasks

  // Getter for accessing the tasks list
  List<Task> get tasks => _tasks;

  // Method to add a task
  void addTask(String name) {
    _tasks.add(Task(name));
    notifyListeners(); // Notify listeners (widgets) about the change
  }

  // Method to toggle task completion status
  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners(); // Notify listeners about the change
  }

  // Method to delete a task
  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners(); // Notify listeners about the change
  }
}

// Definition of the main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Providing TaskList to the widget tree
    return ChangeNotifierProvider(
      create: (context) => TaskList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        title: 'To-Do List by Prachi D22IT212', // App title
        theme: ThemeData(
          primarySwatch: Colors.blue, // Theme color
        ),
        // Remove debug banner
        home: TaskListScreen(), // Starting screen of the app
      ),
    );
  }
}

// Definition of the screen widget displaying the task list
class TaskListScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController(); // Controller for text input

  @override
  Widget build(BuildContext context) {
    final taskList = Provider.of<TaskList>(context); // Accessing TaskList from the context

    // Building the screen layout
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List by Prachi D22IT212'), // AppBar title
      ),
      body: ListView.builder(
        itemCount: taskList.tasks.length, // Number of tasks
        itemBuilder: (context, index) {
          final task = taskList.tasks[index]; // Getting a task
          return ListTile(
            title: Text(task.name), // Displaying task name
            leading: Checkbox(
              value: task.isCompleted, // Checkbox value based on task completion status
              onChanged: (newValue) {
                taskList.toggleTaskCompletion(index); // Toggling task completion
              },
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Show a dialog to edit the task
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Edit Task'),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Edit task name',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Save'),
                              onPressed: () {
                                final editedTaskName = _controller.text.trim();
                                if (editedTaskName.isNotEmpty) {
                                  taskList.tasks[index].name = editedTaskName;
                                  taskList.notifyListeners();
                                }
                                Navigator.of(context).pop();
                                _controller.clear();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete), // Delete icon
                  onPressed: () {
                    taskList.deleteTask(index); // Deleting the task
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Showing a dialog to add a task
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Task'), // Dialog title
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Task name'), // Input field for task name
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'), // Cancel button
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                  ),
                  TextButton(
                    child: Text('Add'), // Add button
                    onPressed: () {
                      final taskName = _controller.text.trim(); // Get task name
                      if (taskName.isNotEmpty) {
                        taskList.addTask(taskName); // Add task to the list
                      }
                      Navigator.of(context).pop(); // Dismiss the dialog
                      _controller.clear(); // Clear the text input
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Task', // Tooltip for the button
        child: Icon(Icons.add), // Icon for the button
      ),
    );
  }
}
