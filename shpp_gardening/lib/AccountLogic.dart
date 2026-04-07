import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart'; // REQUIRED to see the TrackedPlant class

class AccountLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- 1. AUTHENTICATION ---

  // LOGIN: Fetches the user's role (Teacher/Student)
  Future<String?> loginUser(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    
    DocumentSnapshot doc = await _db.collection('users').doc(result.user!.uid).get();
    
    if (doc.exists) {
      return doc.get('role'); 
    }
    return null;
  }

  // REGISTER: Creates account and saves role to Firestore
  Future<String?> registerUser(String email, String password, String role) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    
    await _db.collection('users').doc(result.user!.uid).set({
      'email': email,
      'role': role,
      'classCode': '', // The class the student joins
      'myClassCode': '', // The code the teacher generates
    });

    return role;
  }

  // --- 2. CLASS CODE LOGIC ---

  // TEACHERS: Create/Generate a unique random class code
  Future<String> createClass() async {
    final user = _auth.currentUser;
    if (user == null) return "Error: Not Logged In";

    // Generate a unique 6-digit random ID based on timestamp
    final randomSuffix = DateTime.now().millisecondsSinceEpoch.toString().substring(7); 
    String classCode = "GRDN-$randomSuffix"; 

    // 1. Create the Class Document in the global 'classes' collection
    await _db.collection('classes').doc(classCode).set({
      'teacherId': user.uid,
      'teacherEmail': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'active': true,
    });

    // 2. Save it to the Teacher's own profile so it persists on their Home Screen
    await _db.collection('users').doc(user.uid).update({
      'myClassCode': classCode
    });

    return classCode;
  }

  // STUDENTS: Join a class using a code
  Future<bool> joinClass(String code) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    // Normalize input to uppercase to match generated codes
    String formattedCode = code.trim().toUpperCase();

    // Check if the class exists in the 'classes' collection
    DocumentSnapshot classDoc = await _db.collection('classes').doc(formattedCode).get();
    
    if (classDoc.exists) {
      // Link student profile to this class
      await _db.collection('users').doc(user.uid).update({
        'classCode': formattedCode,
      });
      return true;
    }
    return false;
  }

  // FETCH User Data (Role, Class Codes, etc.) for the UI
  Stream<DocumentSnapshot> getUserData() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _db.collection('users').doc(user.uid).snapshots();
  }

  // --- 3. GARDEN LOGIC ---

  // SAVE a plant to the user's account
  Future<void> addPlantToFirebase(String plantName) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    await _db.collection('users').doc(user.uid).collection('myGarden').doc(plantName).set({
      'name': plantName,
      'lastWatered': Timestamp.now(),
      'thirstDuration': 21600, // 6 hours
    });
  }

  // FETCH all plants for the logged-in user
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

  // --- QUIZ LOGIC ---

// TEACHER: Post a quiz from the bank to their class
Future<void> postQuizToClass(String classCode, Map<String, dynamic> quizData) async {
  await _db.collection('classes').doc(classCode).collection('activeQuizzes').add({
    ...quizData,
    'postedAt': FieldValue.serverTimestamp(),
  });
}

// STUDENT: Submit quiz score
Future<void> submitQuizScore(String classCode, String quizTitle, int score, int total) async {
  final user = _auth.currentUser;
  if (user == null) return;

  await _db.collection('classes').doc(classCode).collection('results').add({
    'studentEmail': user.email,
    'studentId': user.uid,
    'quizTitle': quizTitle,
    'score': score,
    'total': total,
    'submittedAt': FieldValue.serverTimestamp(),
  });
}

// TEACHER: Stream of student results
Stream<QuerySnapshot> getStudentResults(String classCode) {
  return _db.collection('classes').doc(classCode).collection('results').orderBy('submittedAt', descending: true).snapshots();
}
}