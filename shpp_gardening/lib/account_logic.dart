import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart'; 
import 'dart:math';

class AccountLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- 1. AUTHENTICATION & PROFILE CREATION ---

  Future<String?> loginUser(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    DocumentSnapshot doc = await _db.collection('users').doc(result.user!.uid).get();
    return doc.exists ? doc.get('role') : null;
  }

  Future<String?> registerUser(String email, String password, String role) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    
    // Initializing the user document with ALL necessary fields to prevent "null" errors
    await _db.collection('users').doc(result.user!.uid).set({
      'email': email,
      'role': role,
      'classCode': '', 
      'myClassCode': '', 
      'totalXP': 0, // Ensures the XP bar doesn't crash on first load
    });
    return role;
  }

  // --- 2. GAMIFICATION (XP & LEVELS) ---

  // Adds XP and returns the new total
  Future<void> addExperience(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'totalXP': FieldValue.increment(amount),
    });
  }

  // A stream that the Homepage uses to update the XP Bar in real-time
  Stream<int> getUserXP() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(0);

    return _db.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) return 0;
      final data = doc.data() as Map<String, dynamic>;
      return data['totalXP'] ?? 0;
    });
  }

  // --- 3. GARDEN DATA ---

  Stream<List<TrackedPlant>> getMyGarden() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    
    return _db.collection('users')
        .doc(user.uid)
        .collection('myGarden')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TrackedPlant(
          name: doc['name'] ?? 'Unknown Plant',
          lastWatered: (doc['lastWatered'] as Timestamp).toDate(),
          thirstDuration: Duration(seconds: doc['thirstDuration'] ?? 21600), //ToDo adjust to be oer plant
        );
      }).toList();
    });
  }

  // Removes a specific plant document from the sub-collection
  Future<void> removePlantFromGarden(String plantName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _db.collection('users')
        .doc(user.uid)
        .collection('myGarden')
        .where('name', isEqualTo: plantName)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // --- 4. CLASSROOM & QUIZ LOGIC ---

  Future<String> createClass() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    String newCode = Iterable.generate(6, (_) => chars[Random().nextInt(chars.length)]).join();

    await _db.collection('classes').doc(newCode).set({
      'teacherId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('users').doc(user.uid).update({
      'myClassCode': newCode,
    });

    return newCode;
  }

  Future<bool> joinClass(String code) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    DocumentSnapshot classDoc = await _db.collection('classes').doc(code).get();
    if (!classDoc.exists) return false;

    await _db.collection('users').doc(user.uid).update({
      'classCode': code,
    });

    return true;
  }

  Future<void> postQuizToClass(String classCode, Map<String, dynamic> quizData) async {
    await _db.collection('classes').doc(classCode).collection('activeQuizzes').add({
      ...quizData,
      'postedAt': FieldValue.serverTimestamp(),
    });
  }

  // NEW: Optimized method for students to submit and get rewarded
  Future<void> submitQuizAndReward({
    required String classCode,
    required String quizTitle,
    required int score,
    required int totalQuestions,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // 1. Record the score for the teacher
    await _db.collection('classes').doc(classCode).collection('results').add({
      'studentEmail': user.email,
      'quizTitle': quizTitle,
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. Award XP (10 points per correct answer)
    await addExperience(score * 10);
  }

  Stream<QuerySnapshot> getStudentResults(String classCode) {
    return _db.collection('classes').doc(classCode).collection('results').snapshots();
  }
}