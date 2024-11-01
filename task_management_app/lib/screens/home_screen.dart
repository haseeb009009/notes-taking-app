// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Manager'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today\'s Tasks'),
              Tab(text: 'Completed Tasks'),
              Tab(text: 'Repeated Tasks'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TaskListWidget(filter: 'today'),
            TaskListWidget(filter: 'completed'),
            TaskListWidget(filter: 'repeated'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to Add Task Screen (to be implemented)
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
