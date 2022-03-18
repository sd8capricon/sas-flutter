// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:sas/variables.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlreadyExists implements Exception {
  String cause;
  AlreadyExists(this.cause);
}

class CreateAttendance extends StatefulWidget {
  const CreateAttendance({Key? key}) : super(key: key);

  @override
  State<CreateAttendance> createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  var lecController = TextEditingController();
  List studentList = [];
  List absentStudents = [];

  void getStudents() async {
    String message = '';
    final url = Uri.parse('$host/students');
    try {
      var students = await http.get(url);
      setState(() {
        studentList = jsonDecode(students.body);
        for (var item in studentList) {
          item['student_status'] = true;
        }
      });
    } on Exception catch (e) {
      message = 'Error Getting Students';
      final snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void mark() async {
    String message = '';
    absentStudents = [];
    List temp = [];
    for (var item in studentList) {
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
    try {
      int currLec = int.parse(lecController.text);
      final url = Uri.parse('$host/get-last-lec/1/');
      final res = await http.get(url);
      switch (res.statusCode) {
        case 400:
          throw Exception("Status Code 400");
      }
      var lastLec = jsonDecode(res.body)['last_lec'];
      if (currLec < lastLec) {
        throw AlreadyExists('cause');
      }
      if (currLec > lastLec) {
        final url = Uri.parse('$host/attendance/0/$currLec/');
        final req = await http.post(url,
            headers: {'Content-type': 'application/json'},
            body: jsonEncode(absentStudents));
        switch (req.statusCode) {
          case 400:
            throw Exception("Status Code 400");
        }
      }
      message = 'Successfully Marked Attendance';
    } on AlreadyExists catch (e) {
      message = 'Lecture already marked';
    } on FormatException catch (e) {
      message = 'Lecture Number cannot be empty';
    } on Exception catch (e) {
      message = 'Error Marking Attendance';
    }
    final snackBar = SnackBar(
      content: Text(message),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enter Lecture Number: '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: lecController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: studentList.length,
              itemBuilder: (context, item) {
                return CheckboxListTile(
                  title: Text(studentList[item]['roll_no'].toString() +
                      " " +
                      studentList[item]['f_name'] +
                      " " +
                      studentList[item]['l_name']),
                  value: !studentList[item]['student_status'],
                  onChanged: (val) {
                    setState(() {
                      studentList[item]['student_status'] = !val!;
                    });
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: mark,
              child: const Text('Mark'),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
