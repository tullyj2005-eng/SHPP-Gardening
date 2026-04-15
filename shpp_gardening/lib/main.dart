import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// Your file imports
import 'account_logic.dart';
import 'info_screen.dart';
import 'login_page.dart';
import 'home_page.dart'; // Ensure this matches your sidebar file name
import 'settings_logic.dart'; //

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
    // STEP 3: Listen to theme changes globally
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode, //
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SHPP Gardening',
          
          // Light Theme configuration
          theme: ThemeData(
            primarySwatch: Colors.green,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          
          // Dark Theme configuration
          darkTheme: ThemeData(
            primarySwatch: Colors.green,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          
          // This tells Flutter which theme to use based on the Settings toggle
          themeMode: currentMode, 
          
          home: const AuthCheck(),
        );
      },
    );
  }
}

// --- AUTH GATEKEEPER ---
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
            builder: (context, userDoc) {
              if (!userDoc.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
              String role = userDoc.data!.get('role') ?? 'Student';
              return HomePage(userRole: role);
            },
          );
        }
        return const LoginPage();
      },
    );
  }
}

// --- PLANT MODEL ---
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
}

// --- HOME PAGE (NAVIGATION) ---
class HomePage extends StatefulWidget {
  final String userRole;
  const HomePage({super.key, required this.userRole});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _handleTracking(String plantName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('myGarden').add({
        'name': plantName,
        'lastWatered': Timestamp.now(),
        'thirstDuration': 21600,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$plantName added to your garden!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TrackedPlant>>(
      stream: AccountLogic().getMyGarden(),
      builder: (context, plantSnapshot) {
        final currentPlants = plantSnapshot.data ?? [];

        final List<Widget> widgetOptions = [
          HomeScreen(tracked: currentPlants, userRole: widget.userRole), 
          InfoScreen(onTrack: _handleTracking),
        ];

        return Scaffold(
          body: widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Info'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF2E7D32),
            onTap: (index) => setState(() => _selectedIndex = index),
          ),
        );
      }
    );
  }
}


// --- LEVEL CALCULATION ---
class LevelCalculator {
  // Define how much XP is needed for each level
  static const int xpPerLevel = 100;

  /// Calculates the current level based on total XP.
  /// Example: 0-99 XP = Level 1, 100-199 XP = Level 2.
  static int getLevel(int totalXP) {
    if (totalXP < 0) return 1;
    return (totalXP / xpPerLevel).floor() + 1;
  }

  /// Calculates the progress (0.0 to 1.0) towards the NEXT level.
  /// This is used directly by the LinearProgressIndicator 'value' property.
  static double getLevelProgress(int totalXP) {
    if (totalXP < 0) return 0.0;
    
    // Get the remainder of XP after accounting for completed levels
    int xpInCurrentLevel = totalXP % xpPerLevel;
    
    // Return as a decimal (e.g., 45 XP / 100 = 0.45)
    return xpInCurrentLevel / xpPerLevel;
  }

  /// Optional: Calculates how much XP is left until the next level.
  /// Useful if you want to show a "50 XP until Level 3" label.
  static int xpUntilNextLevel(int totalXP) {
    int xpInCurrentLevel = totalXP % xpPerLevel;
    return xpPerLevel - xpInCurrentLevel;
  }
}