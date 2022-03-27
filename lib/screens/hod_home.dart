import 'package:flutter/material.dart';

// pub packages
import 'package:shared_preferences/shared_preferences.dart';

// Components
import 'package:sas/components/HodHomeDrawer.dart';

// Screens
import 'login.dart';
import 'package:sas/screens/student.dart';

class HodHome extends StatefulWidget {
  const HodHome({Key? key}) : super(key: key);

  @override
  State<HodHome> createState() => _HodHomeState();
}

class _HodHomeState extends State<HodHome> {
  bool isLoggedIn = false;
  int _selectedIndex = 0;

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('teacher');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  void checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      logOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } else {
      // ??
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.boy),
            label: 'Student',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.work),
          //   label: 'Teacher',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: pages[_selectedIndex],
    );
  }

  final pages = [
    const HomePage(),
    const Student(),
  ];
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOD Home"),
      ),
      drawer: const HodDrawer(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Student()),
                  )
                },
                child: const Text('Student'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
