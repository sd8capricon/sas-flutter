import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sas/variables.dart';

import 'package:http/http.dart' as http;

import 'package:sas/components/Loader.dart';

class AllStudents extends StatefulWidget {
  const AllStudents({Key? key}) : super(key: key);

  @override
  State<AllStudents> createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  bool isLoading = true;
  List students = [];

  void getStudents() async {
    final url = Uri.parse('$host/students');
    final res = await http.get(url);
    if (mounted) {
      setState(() {
        students = jsonDecode(res.body);
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
            DataColumn(label: Text('Roll Number')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Attendance')),
          ],
          rows: students
              .map(
                (e) => DataRow(
                  cells: [
                    DataCell(
                      Center(
                        child: Text(e['roll_no'].toString()),
                      ),
                    ),
                    DataCell(
                      Text(e['f_name'] + " " + e['l_name']),
                    ),
                    DataCell(
                      Center(
                        child:
                            Text(e['total_attendance_percentage'].toString()),
                      ),
                    ),
                  ],
                ),
              )
              .toList()),
    );
  }
}
