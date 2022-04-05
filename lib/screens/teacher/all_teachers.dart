import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sas/variables.dart';

import 'package:http/http.dart' as http;

// Components
import 'package:sas/components/Loader.dart';

class AllTeachers extends StatefulWidget {
  const AllTeachers({Key? key}) : super(key: key);

  @override
  State<AllTeachers> createState() => _AllTeachersState();
}

class _AllTeachersState extends State<AllTeachers> {
  bool isLoading = true;
  List teachers = [];

  void getStudents() async {
    final url = Uri.parse('$host/teachers');
    final res = await http.get(url);
    if (mounted) {
      setState(() {
        teachers = jsonDecode(res.body);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loader;
    }
    return FittedBox(
      alignment: Alignment.topLeft,
      child: DataTable(
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Course Assigned')),
          ],
          rows: teachers
              .map(
                (e) => DataRow(
                  cells: [
                    DataCell(
                      Center(
                        child: Text(e['teacher_id'].toString()),
                      ),
                    ),
                    DataCell(
                      Text(e['f_name'] + " " + e['l_name']),
                    ),
                    DataCell(
                      Center(
                        child: Text(e['course_taught'].toString()),
                      ),
                    ),
                  ],
                ),
              )
              .toList()),
    );
  }
}
