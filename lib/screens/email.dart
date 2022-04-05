import 'package:flutter/material.dart';
import 'package:sas/variables.dart';

// Pub packages
import 'package:http/http.dart' as http;

// Components

class EmailDefaultor extends StatefulWidget {
  const EmailDefaultor({Key? key}) : super(key: key);

  @override
  State<EmailDefaultor> createState() => _EmailDefaultorState();
}

class _EmailDefaultorState extends State<EmailDefaultor> {
  final formKey = GlobalKey<FormState>();
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  bool err = false;

  void sendMail() async {
    Map payload = {
      'title': subjectController.text,
      'body': bodyController.text
    };
    final url = Uri.parse('$host/email-defaultors/');
    final res = await http.post(url, body: payload);
    switch (res.statusCode) {
      case 400:
        err = true;
        break;
      case 200:
        const snackBar = SnackBar(
          content: Text('Mail has been sent'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
        break;
      default:
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subjectController.dispose();
    bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Defaultors'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
        child: err == false
            ? Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subject',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: subjectController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email Body'),
                      ),
                    ),
                    const Text(
                      'Body',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: bodyController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        minLines: 10,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email Body'),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            sendMail();
                          }
                        },
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: const [
                            Text('Mail'),
                            SizedBox(width: 10),
                            Icon(Icons.mail)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : AlertDialog(
                title: const Text('No Attendance to Edit !'),
                actions: [
                  TextButton(
                    onPressed: () {
                      print('Going back');
                    },
                    child: const Text('Go back'),
                  ),
                ],
              ),
      ),
    );
  }
}
