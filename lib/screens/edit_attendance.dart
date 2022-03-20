import 'dart:convert';
import 'package:sas/variables.dart';

// Packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditAttendance extends StatefulWidget {
  const EditAttendance({Key? key}) : super(key: key);

  @override
  State<EditAttendance> createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
  int courseId = 0;
  int currLec = 1;
  int lecs = 0;
  String message = '';
  List menuItems = [];
  List studentList = [];
  List changeStudents = [];

  void dropDownCallback(int? value) async {
    setState(() {
      currLec = value!;
    });
    getAttendance();
  }

  void getStats() async {
    final localStorage = await SharedPreferences.getInstance();
    int idTemp = 0;
    if (localStorage.getInt('course_id') != null) {
      idTemp = localStorage.getInt('course_id')!;
    }
    final url = Uri.parse('$host/course-lec-stats/$idTemp');
    final res = await http.get(url);
    final body = jsonDecode(res.body);
    setState(() {
      lecs = body['num_lecs'];
      courseId = idTemp;
    });
    getAttendance();
  }

  void getAttendance() async {
    final url = Uri.parse('$host/attendance/$courseId/$currLec/');
    final res = await http.get(url);
    final students = jsonDecode(res.body);
    setState(() {
      studentList = students['attendance'];
    });
  }

  void mark() async {
    List updateData = [];
    for (var item in changeStudents) {
      var data = {
        'student_status': item['student_status'],
        'student': item['student']['roll_no']
      };
      updateData.add(data);
    }
    try {
      final url = Uri.parse('$host/attendance/$courseId/$currLec/');
      final res = await http.patch(url,
          headers: {'Content-type': 'application/json'},
          body: jsonEncode(updateData));
      switch (res.statusCode) {
        case 400:
          throw Exception("Status code 400");
      }
      message = 'Successfully Marked Attendance';
    } on Exception catch (e) {
      print(e);
      message = 'Error Marking Attendance';
    }
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Lecture Attendance'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: currLec,
                items: [
                  for (var i = 1; i <= lecs; i++)
                    DropdownMenuItem(
                      child: Text(i.toString()),
                      value: i,
                    )
                ],
                onChanged: dropDownCallback,
              ),
            ],
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: studentList.length,
            itemBuilder: (context, item) {
              return CheckboxListTile(
                title: Text(studentList[item]['student']['roll_no'].toString() +
                    " " +
                    studentList[item]['student']['f_name'] +
                    " " +
                    studentList[item]['student']['l_name']),
                value: !studentList[item]['student_status'],
                onChanged: (val) {
                  setState(() {
                    studentList[item]['student_status'] = !val!;
                    if (changeStudents.contains(studentList[item])) {
                      changeStudents.remove(studentList[item]);
                    } else {
                      changeStudents.add(studentList[item]);
                    }
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
    );
  }
}
