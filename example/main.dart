import 'dart:math';

import 'package:flutter/material.dart';
import 'package:resizable_datatable/resizable_datatable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DataTablePage(),
    );
  }
}

class DataTablePage extends StatefulWidget {
  const DataTablePage({super.key});

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('dataTable'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ResizableDataTable(
          autoFit: true,
          headerHeight: 30,
          header: List.generate(
              3,
              (index) =>
                  ResizableHeader('Column $index', minWidth: 30, width: 100)),
          data: List.generate(
              4,
              (index) => List.generate(3, (col) {
                    final text =
                        'ID $index Col $col ${'1' * Random().nextInt(50)}';
                    return text;
                  })),
        ),
      ),
    );
  }
}
