import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// Your file imports
import 'account_logic.dart';
import 'info_screen.dart';
import 'login_page.dart';
import 'home_page.dart'; 
import 'settings_logic.dart';

// 1. Move Theme Definitions outside the widget tree to avoid syntax errors
final ThemeData greenTheme = ThemeData(
  primarySwatch: Colors.green,
  useMaterial3: true,
  brightness: Brightness.light,
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.green,
  useMaterial3: true,
  brightness: Brightness.dark,
);

final ThemeData redTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 235, 90, 80),
    primary: const Color.fromARGB(255, 235, 90, 80),
    secondary: const Color.fromARGB(255, 161, 16, 3),
  ),
);

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
    // Listen to theme changes globally
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode, 
      builder: (context, currentMode, child) {
        
        // Logic to decide between the standard green and the custom red theme
        // You can link 'isRedSelected' to a ValueNotifier in SettingsLogic later
        bool useRed = ThemeManager.isRedMode; 

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SHPP Gardening',
          
          // Selection logic for themes
          theme: useRed ? redTheme : greenTheme,
          darkTheme: darkTheme,
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
              
              // Handle case where user document or role might be missing
              final data = userDoc.data?.data() as Map<String, dynamic>?;
              String role = (data != null && data.containsKey('role')) ? data['role'] : 'Student';
              
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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Αρχική'),
              BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Πληροφορίες'),
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
  static const int xpPerLevel = 100;

  static int getLevel(int totalXP) {
    if (totalXP < 0) return 1;
    return (totalXP / xpPerLevel).floor() + 1;
  }

  static double getLevelProgress(int totalXP) {
    if (totalXP < 0) return 0.0;
    int xpInCurrentLevel = totalXP % xpPerLevel;
    return xpInCurrentLevel / xpPerLevel;
  }

  static int xpUntilNextLevel(int totalXP) {
    int xpInCurrentLevel = totalXP % xpPerLevel;
    return xpPerLevel - xpInCurrentLevel;
  }
}