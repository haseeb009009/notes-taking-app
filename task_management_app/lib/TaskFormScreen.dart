import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({super.key, this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();
  bool _isRepeated = false;
  final List<String> _subtasks = [];
  final List<bool> _subtaskCompletion = [];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskProvider = context.read<TaskProvider>();

      final newTask = TaskModel(
        title: _title,
        description: _description,
        dueDate: _dueDate,
        isRepeated: _isRepeated,
        subtasks: _subtasks,
        subtaskCompletion: _subtaskCompletion,
      );

      if (widget.task == null) {
        taskProvider.addTask(newTask);
      } else {
        // If editing, update the task properties and save
        widget.task!.title = _title;
        widget.task!.description = _description;
        widget.task!.dueDate = _dueDate;
        widget.task!.isRepeated = _isRepeated;
        widget.task!.subtasks = _subtasks;
        widget.task!.subtaskCompletion = _subtaskCompletion;
        taskProvider.loadTasks();
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'New Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                initialValue: widget.task?.title,
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                initialValue: widget.task?.description,
                onSaved: (value) => _description = value!,
              ),
              ListTile(
                title: Text('Due Date: ${_dueDate.toLocal()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => _dueDate = date);
                  }
                },
              ),
              CheckboxListTile(
                title: const Text('Repeated'),
                value: _isRepeated,
                onChanged: (value) {
                  setState(() => _isRepeated = value!);
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
