import 'package:flutter/material.dart';

// Components
import 'package:sas/components/HodHomeDrawer.dart';

// Screens
import 'package:sas/screens/email.dart';

class DeafultorList extends StatefulWidget {
  const DeafultorList({Key? key}) : super(key: key);

  @override
  State<DeafultorList> createState() => _DeafultorListState();
}

class _DeafultorListState extends State<DeafultorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Defaultor List'),
      ),
      drawer: const HodDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Deafaultor List'),
          Center(
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
    );
  }
}
