import 'package:flutter/material.dart';
import 'InfoScreen.dart';
import 'dart:async'; 
import 'HomePage.dart'; // Ensure this points to where HomeScreen is defined

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SHPP Gardening',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

// --- 1. DATA MODEL (Fixed brackets and logic) ---
class TrackedPlant {
  final String name;
  final DateTime lastWatered;
  final Duration thirstDuration;

  TrackedPlant({
    required this.name, 
    required this.lastWatered, 
    this.thirstDuration = const Duration(hours: 6),
  });

  // This calculates the progress percentage (0.0 to 1.0)
  double get waterProgress {
    final timePassed = DateTime.now().difference(lastWatered);
    double progress = timePassed.inSeconds / thirstDuration.inSeconds;
    return progress.clamp(0.0, 1.0);
  }
}

// --- 2. HOME PAGE (STATEFUL) ---
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  // This list must be inside the State class
  List<TrackedPlant> trackedPlants = [];
  Timer? _trackerTimer;

  @override
  void initState() {
    super.initState();
    // Refresh the UI every second to update the progress bars
    _trackerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && trackedPlants.isNotEmpty) {
        setState(() {}); 
      }
    });
  }

  @override
  void dispose() {
    _trackerTimer?.cancel();
    super.dispose();
  }

  // Logic to add a new plant
  void _handleTracking(String plantName) {
    setState(() {
      bool alreadyExists = trackedPlants.any((p) => p.name == plantName);
      if (!alreadyExists) {
        trackedPlants.add(TrackedPlant(
          name: plantName, 
          lastWatered: DateTime.now(), 
          thirstDuration: const Duration(hours: 6), 
        ));
        _selectedIndex = 0; // Redirect to Home tab
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We define this INSIDE the build method so it can see trackedPlants and _handleTracking
    final List<Widget> _widgetOptions = [
      HomeScreen(tracked: trackedPlants), 
      InfoScreen(onTrack: _handleTracking),
      QuizScreen(),
    ];

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- PLACEHOLDER QUIZ SCREEN ---
class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Quiz Screen')));
  }
}