import 'dart:convert';
import 'package:sas/variables.dart';

// Packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Components
import 'package:sas/components/Loader.dart';

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
  bool isLoading = true;
  int courseId = 0;
  List studentList = [];
  List absentStudents = [];

  void getLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        if (localStorage.getInt('course_id') != null) {
          courseId = localStorage.getInt('course_id')!;
        }
      });
      getStudents();
    }
  }

  void getStudents() async {
    String message = '';
    final url = Uri.parse('$host/course/$courseId');
    try {
      var students = await http.get(url);
      if (mounted) {
        setState(() {
          studentList = jsonDecode(students.body)['enrolled_students'];
          for (var item in studentList) {
            item['student_status'] = true;
          }
        });
      }
    } on Exception catch (e) {
      message = 'Error Getting Students';
      final snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isLoading = false;
    });
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
      final url = Uri.parse('$host/get-last-lec/$courseId/');
      final res = await http.get(url);
      switch (res.statusCode) {
        case 400:
          throw Exception("Status Code 400 last lec");
      }
      var lastLec = jsonDecode(res.body)['last_lec'];
      if (currLec <= lastLec) {
        throw AlreadyExists('cause');
      }
      if (currLec > lastLec) {
        final url = Uri.parse('$host/attendance/$courseId/$currLec/');
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
      print(e);
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
    getLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loader;
    }
    return Container(
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
    );
  }
}
