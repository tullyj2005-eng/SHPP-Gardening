import 'package:flutter/material.dart';
import 'InfoScreen.dart';
import 'dart:async'; 
import 'HomePage.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ADD THIS IMPORT
import 'firebase_options.dart';
import 'AccountLogic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SHPP Gardening',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

// --- DATA MODEL ---
class TrackedPlant {
  final String name;
  final DateTime lastWatered;
  final Duration thirstDuration;

  TrackedPlant({
    required this.name, 
    required this.lastWatered, 
    this.thirstDuration = const Duration(hours: 6),
  });

  double get waterProgress {
    final timePassed = DateTime.now().difference(lastWatered);
    double progress = timePassed.inSeconds / thirstDuration.inSeconds;
    return progress.clamp(0.0, 1.0);
  }

  onClick() {
    // When clicked I want to make sure it spawns a widget with the plant information
  }
}

// --- THE MAIN WRAPPER ---
class HomePage extends StatefulWidget {
  final String? userRole; 
  const HomePage({super.key, this.userRole});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<TrackedPlant> localTrackedPlants = []; // Used for guest mode
  Timer? _trackerTimer;

  @override
  void initState() {
    super.initState();
    // This timer ensures the progress bars update every second
    _trackerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {}); 
      }
    });
  }

  @override
  void dispose() {
    _trackerTimer?.cancel();
    super.dispose();
  }

  void _handleTracking(String plantName) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Permanently save to Firebase
      await AccountLogic().addPlantToFirebase(plantName);
      // Switch to Home tab to see the result
      setState(() => _selectedIndex = 0);
    } else {
      // Guest Mode: Save to local list
      setState(() {
        if (!localTrackedPlants.any((p) => p.name == plantName)) {
          localTrackedPlants.add(TrackedPlant(
            name: plantName, 
            lastWatered: DateTime.now(),
          ));
        }
        _selectedIndex = 0; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        final isLoggedIn = authSnapshot.hasData;

        // If logged in, we use the Firebase Stream. If guest, we use the local list.
        return StreamBuilder<List<TrackedPlant>>(
          stream: isLoggedIn ? AccountLogic().getMyGarden() : Stream.value(localTrackedPlants),
          builder: (context, plantSnapshot) {
            final currentPlants = plantSnapshot.data ?? localTrackedPlants;

            final List<Widget> widgetOptions = [
              HomeScreen(tracked: currentPlants, userRole: widget.userRole), 
              InfoScreen(onTrack: _handleTracking),
              const Center(child: Text("Quiz Section")),
            ];

            return Scaffold(
              body: widgetOptions.elementAt(_selectedIndex),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.green,
                onTap: (index) => setState(() => _selectedIndex = index),
              ),
            );
          }
        );
      }
    );
  }
}