import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAttendance extends StatefulWidget {
  const CreateAttendance({Key? key}) : super(key: key);

  @override
  State<CreateAttendance> createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  List body = [];
  List absentStudents = [];

  void getStudents() async {
    final url = Uri.parse('http://192.168.0.5:8000/students');
    var res = await http.get(url);
    setState(() {
      body = jsonDecode(res.body);
      // body = jsonDecode(res.body)["enrolled_students"]
      for (var item in body) {
        item['student_status'] = true;
      }
    });
  }

  void mark() {
    absentStudents = [];
    List temp = [];
    for (var item in body) {
      bool stat = item['student_status'];
      if (stat == false) {
        var data = {
          'student_status': item['student_status'],
          'student': item['roll_no']
        };
        temp.add(data);
      }
    }
    setState(() {
      absentStudents = temp;
    });
    if (absentStudents.isNotEmpty) {
      // TODO: write logic to post server
      print(absentStudents);
      print('make http post req here');
    }
  }

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
      ),
      body: Container(
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: body.length,
              itemBuilder: (context, item) {
                return CheckboxListTile(
                  title: Text(body[item]['roll_no'].toString() +
                      " " +
                      body[item]['f_name'] +
                      " " +
                      body[item]['l_name']),
                  value: !body[item]['student_status'],
                  onChanged: (val) {
                    setState(() {
                      body[item]['student_status'] = !val!;
                    });
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: mark,
              child: const Text('Mark'),
            ),
            Text(absentStudents.isNotEmpty
                ? absentStudents.toString()
                : 'Empty List'),
          ],
        ),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
