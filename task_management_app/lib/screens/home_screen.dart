// lib/screens/home_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/screens/add_task_screen.dart';
import '../providers/task_provider.dart';
import '../services/export_service.dart';
import '../services/theme_service.dart';
import '../widgets/task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  String _searchQuery = "";
  String _sortOption = "none";

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = "";
    });
  }

  void _setSortOption(String option) {
    setState(() {
      _sortOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: !_isSearching
              ? const Text('Task Manager')
              : TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search tasks...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
          actions: [
            _isSearching
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _stopSearch,
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _startSearch,
                  ),
            IconButton(
              icon: Icon(
                themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: () {
                themeService.toggleTheme();
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'csv' || value == 'pdf') {
                  _exportTasks(context, value);
                } else {
                  _setSortOption(value);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'csv', child: Text('Export as CSV')),
                const PopupMenuItem(value: 'pdf', child: Text('Export as PDF')),
                const PopupMenuDivider(),
                const PopupMenuItem(
                    value: 'date', child: Text('Sort by Due Date')),
                const PopupMenuItem(
                    value: 'title', child: Text('Sort by Title')),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today\'s Tasks'),
              Tab(text: 'Completed Tasks'),
              Tab(text: 'Repeated Tasks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskListWidget(
                filter: 'today',
                searchQuery: _searchQuery,
                sortOption: _sortOption),
            TaskListWidget(
                filter: 'completed',
                searchQuery: _searchQuery,
                sortOption: _sortOption),
            TaskListWidget(
                filter: 'repeated',
                searchQuery: _searchQuery,
                sortOption: _sortOption),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _exportTasks(BuildContext context, String format) async {
    final tasks = Provider.of<TaskProvider>(context, listen: false).tasks;
    File? exportFile;

    if (format == 'csv') {
      exportFile = await ExportService.exportToCSV(tasks);
    } else if (format == 'pdf') {
      exportFile = await ExportService.exportToPDF(tasks);
    }

    if (exportFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tasks exported as ${format.toUpperCase()}!')),
      );
    }
  }
}
