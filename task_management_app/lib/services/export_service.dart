// lib/services/export_service.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/task_model.dart';

class ExportService {
  // Export tasks as a CSV file
  static Future<File> exportToCSV(List<Task> tasks) async {
    List<List<String>> csvData = [
      ['ID', 'Title', 'Description', 'Due Date', 'Completed', 'Repeated'],
      ...tasks.map((task) => [
            task.id.toString(),
            task.title,
            task.description,
            task.dueDate.toIso8601String(),
            task.isCompleted ? 'Yes' : 'No',
            task.isRepeated ? 'Yes' : 'No',
          ])
    ];

    String csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks_export.csv';
    final file = File(path);
    return await file.writeAsString(csv);
  }

  // Export tasks as a PDF file
  static Future<File> exportToPDF(List<Task> tasks) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Task List', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['ID', 'Title', 'Description', 'Due Date', 'Completed', 'Repeated'],
              data: tasks.map((task) {
                return [
                  task.id.toString(),
                  task.title,
                  task.description,
                  task.dueDate.toIso8601String(),
                  task.isCompleted ? 'Yes' : 'No',
                  task.isRepeated ? 'Yes' : 'No',
                ];
              }).toList(),
            ),
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks_export.pdf';
    final file = File(path);
    return await file.writeAsBytes(await pdf.save());
  }
}
