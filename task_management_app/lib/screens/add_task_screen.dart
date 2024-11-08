// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For date formatting
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../services/notification_service.dart';  // For notifications


class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  bool _isRepeated = false;

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

void _saveTask(BuildContext context) async {
  if (_formKey.currentState!.validate() && _selectedDate != null) {
    final newTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate!,
      isRepeated: _isRepeated,
    );

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.addTask(newTask);

    // Schedule a notification for the task
    await NotificationService.showNotification(
      id: newTask.id!,
      title: newTask.title,
      body: newTask.description,
      scheduledDate: newTask.dueDate,
    );
    Navigator.pop(context);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Select Due Date'
                          : DateFormat.yMd().format(_selectedDate!),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Pick Date'),
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
                  const Text('Repeat Task'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _saveTask(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 