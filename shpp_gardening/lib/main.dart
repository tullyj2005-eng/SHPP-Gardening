import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'firebase_options.dart';

// Your file imports
import 'account_logic.dart';
import 'info_screen.dart';
import 'login_page.dart';
import 'home_page.dart'; 
import 'settings_logic.dart';
import 'tracked_plant.dart';

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

// Global audio player — lives for the lifetime of the app
final AudioPlayer globalAudioPlayer = AudioPlayer();

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

// --- HOME PAGE (NAVIGATION) ---
class HomePage extends StatefulWidget {
  final String userRole;
  const HomePage({super.key, required this.userRole});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _musicStarted = false;

  @override
  void initState() {
    super.initState();
    // Music is started on first user interaction via the GestureDetector in build()
    // to comply with browser autoplay policy — calling play() here causes a freeze on web.
    ThemeManager.isMuted.addListener(_onMuteChanged);
  }

  @override
  void dispose() {
    ThemeManager.isMuted.removeListener(_onMuteChanged);
    super.dispose();
  }

  void _onMuteChanged() {
    if (ThemeManager.isMuted.value) {
      globalAudioPlayer.pause();
    } else {
      if (_musicStarted) {
        globalAudioPlayer.resume();
      }
      // If not started yet, the GestureDetector will start it on next tap
    }
  }

  void _startMusic() async {
    await globalAudioPlayer.setReleaseMode(ReleaseMode.loop);
    await globalAudioPlayer.play(AssetSource('audio/soundtrack.wav'));
  }

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

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (!_musicStarted && !ThemeManager.isMuted.value) {
              _musicStarted = true;
              _startMusic();
            }
          },
          child: Scaffold(
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