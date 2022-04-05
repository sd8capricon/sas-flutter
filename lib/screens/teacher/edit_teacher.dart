import 'dart:convert';
import 'package:sas/variables.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// Components
import 'package:sas/components/Loader.dart';

class EditTeacher extends StatefulWidget {
  const EditTeacher({Key? key}) : super(key: key);

  @override
  State<EditTeacher> createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  bool isLoading = true;
  final formKey = GlobalKey<FormState>();
  int currId = 1;
  List teachers = [];
  var err = '';
  var uNameController = TextEditingController();
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var passController = TextEditingController();
  var passConfirmController = TextEditingController();

  int binarySearch(List arr, int val) {
    int min = 0;
    int max = arr.length;
    while (max > min) {
      int mid = ((max + min) / 2).floor();
      if (arr[mid]['teacher_id'] == val) {
        return mid;
      } else if (val > arr[mid]['teacher_id']) {
        min = mid++;
      } else if (val < arr[mid]['teacher_id']) {
        max = mid--;
      }
    }
    return -1;
  }

  void setControllers(index) {
    uNameController.text = teachers[index]['username'].toString();
    fNameController.text = teachers[index]['f_name'].toString();
    lNameController.text = teachers[index]['l_name'].toString();
  }

  void dropDownCallback(var value) async {
    setState(() {
      currId = value!;
      int index = binarySearch(teachers, currId);
      setControllers(index);
    });
  }

  void getStudents() async {
    final url = Uri.parse('$host/teachers');
    final res = await http.get(url);
    if (mounted) {
      setState(() {
        teachers = jsonDecode(res.body);
        currId = teachers[0]['teacher_id'];
        setControllers(0);
        isLoading = false;
      });
    }
  }

  void submit() async {
    Map body = {
      'username': uNameController.text,
      'f_name': fNameController.text,
      'l_name': lNameController.text,
    };
    if (passConfirmController.text.isNotEmpty) {
      body['password'] = passController.text;
    }
    final url = Uri.parse('$host/teacher/$currId/');
    final res = await http.patch(url, body: body);
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
          content: Text('Teacher Updated'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
    }
  }

  void remove() async {
    final url = Uri.parse('$host/teacher/$currId/');
    final res = await http.delete(url);
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
          content: Text('Teacher Removed'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
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
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select Teacher id: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  value: currId,
                  items: teachers
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e['teacher_id'].toString()),
                          value: e['teacher_id'],
                        ),
                      )
                      .toList(),
                  onChanged: dropDownCallback,
                ),
              ],
            ),
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
                    controller: uNameController,
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
                    enableSuggestions: false,
                    autocorrect: false,
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
                      if (value != passController.text) {
                        return 'Passwords do not match';
                      }
                    },
                  ),
                  width: 150,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    submit();
                  }
                },
                child: const Text('Update'),
              ),
            ),
            Text(
              err,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: remove,
                  child: const Text('Remove'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
