import 'dart:convert';
import 'package:sas/variables.dart';

import 'package:flutter/material.dart';

// Pub Packages
import 'package:http/http.dart' as http;

class EnrollTeacher extends StatefulWidget {
  const EnrollTeacher({Key? key}) : super(key: key);

  @override
  State<EnrollTeacher> createState() => _EnrollTeacherState();
}

class _EnrollTeacherState extends State<EnrollTeacher> {
  final formKey = GlobalKey<FormState>();
  int currCourse = 0;
  // List courses = [{'course_name': }];
  var err = '';
  var usernameController = TextEditingController();
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var passController = TextEditingController();
  var passConfirmController = TextEditingController();

  // void dropDownCallback(var value) async {
  //   setState(() {
  //     currCourse = value!;
  //   });
  // }

  // void getCourses() async {
  //   final url = Uri.parse('$host/courses');
  //   final res = await http.get(url);
  //   setState(() {
  //     courses = jsonDecode(res.body);
  //     currCourse = courses[0]['course_id'];
  //   });
  // }

  void submit() async {
    Map body = {
      'username': usernameController.text,
      'f_name': fNameController.text,
      'l_name': lNameController.text,
      'password': passController.text,
    };
    final url = Uri.parse('$host/teacher/0/');
    final res = await http.post(url, body: body);
    var data = jsonDecode(res.body);
    switch (res.statusCode) {
      case 400:
        setState(() {
          err = data['error'];
        });
        break;
      case 200:
        setState(() {
          err = '';
        });
        const snackBar = SnackBar(
          content: Text('Teacher Enrolled'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                width: 150,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'First Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: fNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                width: 150,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Last Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: lNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                width: 150,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: passController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                width: 150,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Confirm Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: passConfirmController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value != passController.text) {
                      return 'Passwords do not match';
                    }
                  },
                ),
                width: 150,
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text(
          //       'Assign Course: ',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     DropdownButton(
          //       value: currCourse,
          //       items: courses
          //           .map(
          //             (e) => DropdownMenuItem(
          //               child: Text(e['course_name']),
          //               value: e['course_id'],
          //             ),
          //           )
          //           .toList(),
          //       onChanged: dropDownCallback,
          //     ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  submit();
                }
              },
              child: const Text('Enroll'),
            ),
          ),
          Text(
            err,
            style: const TextStyle(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
