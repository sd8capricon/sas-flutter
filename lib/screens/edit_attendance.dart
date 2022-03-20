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
  List menuItems = [];

  void dropDownCallback(int? value) async {
    setState(() {
      currLec = value!;
    });
  }

  void getStats() async {
    final localStorage = await SharedPreferences.getInstance();
    int id_temp = 0;
    if (localStorage.getInt('course_id') != null) {
      id_temp = localStorage.getInt('course_id')!;
    }
    final url = Uri.parse('$host/course-lec-stats/$id_temp');
    final res = await http.get(url);
    final body = jsonDecode(res.body);
    setState(() {
      lecs = body['num_lecs'];
      courseId = id_temp;
    });
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
        ],
      ),
    );
  }
}
