import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  bool _isRepeated = false;

  void _submitTask() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }
    final task = TaskModel(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
      isRepeated: _isRepeated,
    );
    Provider.of<TaskProvider>(context, listen: false).addTask(task);
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Due Date: ${_dueDate.toLocal()}'.split(' ')[0]),
                TextButton(
                  onPressed: _pickDate,
                  child: Text('Select Date'),
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
                Text('Repeat Task')
              ],
            ),
            ElevatedButton(
              onPressed: _submitTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
