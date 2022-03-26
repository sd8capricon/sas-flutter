import 'dart:convert';
import 'package:sas/variables.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EditStudent extends StatefulWidget {
  const EditStudent({Key? key}) : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final formKey = GlobalKey<FormState>();
  var err = '';
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('First Name'),
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
              const Text('Last Name'),
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
              const Text('Email'),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: emailController,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  print('Hello');
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
