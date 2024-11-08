//lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<TextEditingController> _subtaskControllers = [];
  DateTime _selectedDate = DateTime.now();
  bool _isRepeated = false;

  void _addSubtaskField() {
    setState(() {
      _subtaskControllers.add(TextEditingController());
    });
  }

  void _submitTask() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }
    // Gather subtasks from the subtask controllers
    final subtasks =
        _subtaskControllers.map((controller) => controller.text).toList();
    final task = TaskModel(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      isRepeated: _isRepeated,
      subtasks: subtasks,
      subtaskCompletion: List.filled(subtasks.length, false),
    );
    Provider.of<TaskProvider>(context, listen: false).addTask(task);
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Due Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Select Date'),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _isRepeated,
                  onChanged: (value) {
                    setState(() {
                      _isRepeated = value!;
                    });
                  },
                ),
                const Text('Repeat Task')
              ],
            ),
            // Display subtask input fields
            Column(
              children: _subtaskControllers
                  .map((controller) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(labelText: 'Subtask'),
                        ),
                      ))
                  .toList(),
            ),
            TextButton(
              onPressed: _addSubtaskField,
              child: const Text('Add Subtask'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitTask,
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
