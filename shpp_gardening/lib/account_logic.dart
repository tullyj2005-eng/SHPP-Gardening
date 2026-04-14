import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart'; 
import 'dart:math'; // Required for generating random codes

class AccountLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- 1. AUTHENTICATION ---
  Future<String?> loginUser(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    DocumentSnapshot doc = await _db.collection('users').doc(result.user!.uid).get();
    return doc.exists ? doc.get('role') : null;
  }

  Future<String?> registerUser(String email, String password, String role) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _db.collection('users').doc(result.user!.uid).set({
      'email': email,
      'role': role,
      'classCode': '', 
      'myClassCode': '', 
    });
    return role;
  }

  // --- 2. GARDEN DATA ---
  Stream<List<TrackedPlant>> getMyGarden() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    
    return _db.collection('users').doc(user.uid).collection('myGarden').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TrackedPlant(
          name: doc['name'] ?? 'Unknown Plant',
          lastWatered: (doc['lastWatered'] as Timestamp).toDate(),
          thirstDuration: Duration(seconds: doc['thirstDuration'] ?? 21600),
        );
      }).toList();
    });
  }

  // NEW: Removes a specific plant from the user's garden
  Future<void> removePlantFromGarden(String plantName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Find the document with the matching plant name and delete it
      var snapshot = await _db.collection('users')
          .doc(user.uid)
          .collection('myGarden')
          .where('name', isEqualTo: plantName)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("Error removing plant: $e");
    }
  }

  // --- 3. THE MISSING CLASSROOM METHODS ---

  // TEACHER: Create a new class and save the code
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

  // STUDENT: Join a class using a code
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

  // --- 4. QUIZ LOGIC ---
  Future<void> postQuizToClass(String classCode, Map<String, dynamic> quizData) async {
    await _db.collection('classes').doc(classCode).collection('activeQuizzes').add({
      ...quizData,
      'postedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getStudentResults(String classCode) {
    return _db.collection('classes').doc(classCode).collection('results').snapshots();
  }
}