import 'package:celo_fitness_starter_file/weights_screen.dart';
import 'package:celo_fitness_starter_file/workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  List<Widget> screens = [
    const WorkoutScreen(),
    const WeightScreen(),
  ];

  void _onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Workouts",
            icon: Icon(Icons.fitness_center),
          ),
          BottomNavigationBarItem(
            label: "Weights",
            icon: Icon(Icons.monitor_weight),
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        elevation: 12,
        // type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: _onTapped,
      ),
    );
  }
}
