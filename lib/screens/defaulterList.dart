import 'dart:convert';

import 'package:sas/variables.dart';
import 'package:flutter/material.dart';

// Pub packages
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Components
import 'package:sas/components/HodHomeDrawer.dart';

// Screens
import 'package:sas/screens/email.dart';

class DefaulterList extends StatefulWidget {
  const DefaulterList({Key? key}) : super(key: key);

  @override
  State<DefaulterList> createState() => _DefaulterListState();
}

class _DefaulterListState extends State<DefaulterList> {
  bool isLoading = true;
  List defaulters = [];

  void getDefaulters() async {
    if (mounted) {
      final url = Uri.parse('$host/defaulters');
      final res = await http.get(url);
      var body = jsonDecode(res.body);
      switch (res.statusCode) {
        case 400:
          print(body['error']);
          break;
        case 200:
          setState(() {
            defaulters = body;
          });
          break;
        default:
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDefaulters();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Home'),
        ),
        drawer: const HodDrawer(),
        body: SpinKitDualRing(
          color: Colors.blue,
          size: spinnerSize,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Defaultor List'),
      ),
      drawer: const HodDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Expanded(
                    child: Text(
                      'Roll No',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      'Attendance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: defaulters.length,
                itemBuilder: (context, item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            defaulters[item]['roll_no'].toString(),
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            defaulters[item]['f_name'] +
                                ' ' +
                                defaulters[item]['l_name'],
                            // textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            defaulters[item]['total_attendance_percentage']
                                .toString(),
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmailDefaultor()));
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Text('Mail Deafaultors'),
                    SizedBox(width: 10),
                    Icon(Icons.mail)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
