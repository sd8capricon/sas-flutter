import 'dart:convert';
import 'package:sas/variables.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var loginErr = '';

  void login() async {
    final prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('$host/login/');
    var res = await http.post(url, body: {
      "username": usernameController.text,
      "password": passwordController.text
    });
    var body = jsonDecode(res.body) as Map;
    if (body.containsKey('error')) {
      setState(() {
        loginErr = 'Incorrect Username or Password';
      });
    } else {
      var teacher = body['teacher'];
      var token = body['token'];
      var courseId = body['course_taught'];
      prefs.setString('token', token);
      prefs.setString('teacher', jsonEncode(teacher));
      prefs.remove('course_id');
      if (courseId != null) prefs.setInt('course_id', courseId);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('My Amazing app'),
      ),
      body: Container(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Text('Login'),
                margin: const EdgeInsets.only(bottom: 30),
              ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter username',
                ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text('Login'),
                ),
              ),
              Text(
                loginErr,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50),
      ),
    );
  }
}
