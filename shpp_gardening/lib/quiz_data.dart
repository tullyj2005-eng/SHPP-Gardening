import 'quiz_model.dart'; // Ensure this matches your model filename




/*
// Test Quizzes for the layout
final gardeningQuestions = [
  Question(
    questionText: "I am full of holes but still hold water. What am I?",
    type: "riddle",
    correctAnswer: "Sponge",
  ),
  Question(
    questionText: "Which part of the plant is responsible for absorbing water?",
    type: "multiple_choice",
    correctAnswer: "Roots",
    options: ["Leaves", "Stem", "Flowers", "Roots"],
  ),
];

final techQuestions = [
  Question(
    questionText: "What has keys but can't open locks?",
    type: "riddle",
    correctAnswer: "A piano",
  ),
];

Question(
  questionText: "What has a heart that doesn't beat?",
  type: "multiple_choice",
  correctAnswer: "An artichoke",
  options: ["A heart", "An artichoke", "A piano", "A kidney"],
),

*/



///////////////////////////////////////////////////////////////////////////////


// --- OREGANO QUIZ ---  8Questions - update with new questions
final oreganoQuestions = [
  Question( // 1
    questionText: "Πότε συλλέγεται συνήθως η ρίγανη για αποξήρανση;",
    type: "multiple_choice",
    correctAnswer: "Στην αρχή της ανθοφορίας",
    options: ["Πριν αναπτυχθεί", "Στην αρχή της ανθοφορίας", "Το χειμώνα", "Αφού ξεραθεί/πεθάνε"],
  ),
  Question( // 2
    questionText: "Πότε συλλέγεται η ρίγανη για αιθέριο έλαιο;",
    type: "multiple_choice",
    correctAnswer: "Σε πλήρη ανθοφορία",
    options: ["Μόνο κατά το πρώτο έτος", "Πριν τη φύτευση", "Σε πλήρη ανθοφορία", "Στις αρχές του χειμώνα"],
  ),
  Question( // 3
    questionText: "Πότε μπορεί να φυτευτεί η ρίγανη;",
    type: "multiple_choice",
    correctAnswer: "Φθινόπωρο ή νωρίς την άνοιξη",
    options: ["Μόνο το καλοκαίρι", "Μόνο το χειμώνα", "Μόνο τη νύχτα", "Φθινόπωρο ή νωρίς την άνοιξη"],
  ),
  Question( // 4
    questionText: "Πόσο νερό χρειάζεται συνήθως η ρίγανη;",
    type: "multiple_choice",
    correctAnswer: "Πολύ λίγο νερό",
    options: ["Πολύ νερό κάθε μέρα", "Μόνο το νερό της βροχής", "Ποτέ καθόλου νερό", "Πολύ λίγο νερό"],
  ),
  Question( // 5
    questionText: "Τι είδους ηλιακό φως χρειάζεται η ρίγανη;",
    type: "multiple_choice",
    correctAnswer: "Μερικό φως ή πλήρες ηλιακό φως",
    options: ["Μερικό φως ή πλήρες ηλιακό φως", "Καθόλου ηλιακό φως", "Μόνο σκιά", "Μόνο τεχνητό φως"],
  ),
  Question( // 6
    questionText: "Τι είδους έδαφος είναι καλύτερο για τη ρίγανη;",
    type: "multiple_choice",
    correctAnswer: "Έδαφος με πολύ καλή αποστράγγιση",
    options: ["Παγωμένο έδαφος", "Έδαφος με πολύ καλή αποστράγγιση", "Μόνο πλούσιο, μαλακό έδαφος", "Υγρό και λασπώδες έδαφος"],
  ),
  Question( // 7
    questionText: "Πως πρέπει να αποξηραίνεται η ρίγανη για την καλύτερη ποιότητα;",
    type: "multiple_choice",
    correctAnswer: "Σε σκοτεινό, καλά αεριζόμενο μέρος",
    options: ["Μέσα στο νερό", "Σε άμεσο ηλιακό φως όλη τη μέρα", "Σε καταψύκτη", "Σε σκοτεινό, καλά αεριζόμενο μέρος"],
  ),
  Question( // 8
    questionText: "Πως πρέπει να αποθηκεύεται η αποξηραμένη ρίγανη;",
    type: "multiple_choice",
    correctAnswer: "Σε καθαρά, στεγνα δοχεία",
    options: ["Σε εξωτερικό χώρο", "Σε καθαρά, στεγνα δοχεία", "Μέσα στον χειμώνα", "Σε υγρά δοχεία"],
  ),
];



// --- SAGE QUIZ ---  8Questions
final sageQuestions = [
  Question(
    questionText: " Πότε είναι η καλύτερη περίοδος για τη συγκομιδή του φασκόμηλου;",
    type: "multiple_choice",
    correctAnswer: "Λίγο πριν την ανθοφορία",
    options: ["Μετά την ανθοφορία", "Λίγο πριν την ανθοφορία", "Στα μέσα του χειμώνα", "Μόνο κατά τον πρώτο χρόνο"],
  ),
  Question(
    questionText: "Πόσες φορές το χρόνο μπορεί, συνήθως, να γίνει η συγκομιδή του φασκόμηλου, μετά το δεύτερο χρόνο;",
    type: "multiple_choice",
    correctAnswer: "Δύο φορές",
    options: ["Τρεις φορές", "Μία φορά", "Μόνο κάθε δύο χρόνια", "Δύο φορές"],
  ),
  Question( //
    questionText: "Τι είδους έδαφος χρειάζεται το φασκόμηλο;",
    type: "multiple_choice",
    correctAnswer: "Καλά αποστραγγιζόμενο έδαφος",
    options: ["Πολύ υγρό έδαφος", "Καλά αποστραγγιζόμενο έδαφος", "Παγωμένο έδαφος", "Μόνο ξηρό έδαφος"],
  ),
  Question( //4
    questionText: "Πως πρέπει να ποτίζετε το φασκόμηλο κατά τη διάρκεια του ζεστού καιρού;",
    type: "multiple_choice",
    correctAnswer: "Ποτίζετε σταθερά κατά τη διάρκεια της ξηρασίας και της ζέστης",
    options: ["Ποτίζετε σταθερά κατά τη διάρκεια της ξηρασίας και της ζέστης", "Μην το ποτίζετε καθόλου", "Ποτίζετε το με άφθονο νερό", "Ποτίζετε το μία φορά το μήνα"],
   ),
  Question(
    questionText: "Σε τι είναι πιο ευαίσθητο το φασκόμηλο;",
    type: "multiple_choice",
    correctAnswer: "Στον υπερβολικό νερό",
    options: ["Στον κρύο καιρό", "Στον υπερβολικό ήλιο", "Στον υπερβολικό νερό", "Στον αέρα"],
   ),
   Question(
    questionText: "Γιατί είναι σημαντικό το κλάδεμα του φασκόμηλου νωρίς την άνοιξη;",
    type: "multiple_choice",
    correctAnswer: "Για να αφαιρεθούν τα νεκρά τμήματα και να βοηθηθεί η ανάπτυξη",
    options: ["Για να σταματήσει η ανάπτυξή του", "Για να αφαιρεθούν τα νεκρά τμήματα και να βοηθηθεί η ανάπτυξη", "Για να αλλάξει το χρώμα του", "Για να γίνει πιο ψηλό"],
   ),
   Question( //7
    questionText: "Πότε φυτεύεται το φασκόμηλο;",
    type: "multiple_choice",
    correctAnswer: "Την άνοιξη ή το φθινόπωρο",
    options: ["Οποιαδήποτε στιγμή του χρόνου", "Μόνο το καλοκαίρι", "Την άνοιξη ή το φθινόπωρο", "Μόνο το χειμώνα"],
   ),
   Question( //8
    questionText: "Τι πρέπει να κάνετε πριν αποξηράνετε τα φύλλα του φασκόμηλου;",
    type: "multiple_choice",
    correctAnswer: "Να καθαρίζετε και να αφαιρέσετε τα φύλλα από τα κλαδιά",
    options: ["Να τα καταψύξετε", "Να τα βάψετε", "Να τα βράσετε", "Να καθαρίζετε και να αφαιρέσετε τα φύλλα από τα κλαδιά"],
   )
];

// --- DITTANY QUIZ ---  7Questions
final dittanyQuestions = [
  Question( // 1
    questionText: "Πότε φυτεύεται, συνήθως, το δίκταμο στο χωράφι;",
    type: "multiple_choice",
    correctAnswer: "Την άνοιξη και το φθινόπωρο",
    options: ["Την άνοιξη και το φθινόπωρο", "Μόνο το καλοκαίρι", "Οποιαδήποτε στιγμή, ανάλογα με την ανθοφορία", "Μόνο μετά την συγκομιδή"],
  ),
  Question( // 2
    questionText: "Πότε συλλέγονται οι ανθισμένες κορυφές του δίκταμου;",
    type: "multiple_choice",
    correctAnswer: "Στο πρώτο στάδιο της ανθοφορίας",
    options: ["Πριν ξεκινήσει η ανθοφορία", "Στο πρώτο στάδιο της ανθοφορίας", "Μετά το τέλος της πλήρους ανθοφορίας", "Τον χειμώνα μετά τον λήθαργο"],
  ),
  Question( // 3
    questionText: "Τι συνθήκες ανάπτυξης προτιμά το δίκταμο;",
    type: "multiple_choice",
    correctAnswer: "Άφθονο ηλιακό φως και σχετικά υψηλές θερμοκρασίες",
    options: ["Σκιά με συχνό πότισμα", "Κρυά κλίματα χωρίς έκθεση στον ήλιο", "Άφθονο ηλιακό φως και σχετικά υψηλές θερμοκρασίες", "Μόνο ελεγχόμενη υγρασία σε εσωτερικό χώρο"],
  ),
  Question( // 4
    questionText: "Πόσο συχνά ποτίζεται το δίκταμο το χειμώνα αν δεν βρέχει;",
    type: "multiple_choice",
    correctAnswer: "Κάθε 10-15 μέρες",
    options: ["Κάθε 10-15 μέρες", "Κάθε 2-3 μέρες", "Μία φορά τον μήνα", "Μόνο κατά το καλοκαίρι"],
  ),
  Question( // 5
    questionText: "Ποιό είναι το μεγαλύτερο ρίσκο κατά την φροντίδα του δίκταμου;",
    type: "multiple_choice",
    correctAnswer: "To υπερβολικό πότισμο, το οποίο οδηγεί σε ασθένειες",
    options: ["To υπερβολικό πότισμα, το οποίο οδηγεί σε ασθένειες", "Η έλλειψη επικονίασης", "Η έκθεση στον υπερβολικό ήλιο", "Το μόνιμο πάγωμα του εδάφους"],
  ),
  Question( // 6
    questionText: "Σε τι υψόμετρο αναπτύσσεται καλύτερα το δίκταμο;",
    type: "multiple_choice",
    correctAnswer: "Πάνω από τα 300 μέτρα",
    options: ["Κάτω από την επιφάνεια της θάλασσας", "Πάνω από τα 300 μέτρα", "Μόνο στο επίπεδο της θάλασσας", "Μόνο πάνω από τα 2000 μέτρα"],
  ),
  Question( // 7
    questionText: "Πως θα πρέπει να αποξηραίνεται το δίκταμο μετά τη συγκομιδή;",
    type: "multiple_choice",
    correctAnswer: "Σε σκοτεινό, ξηρό μέρος ή στους 35°C σε ξηραντήριο",
    options: ["Σε άμεσο ηλιακό φως σε εξωτερικό χώρο", "Σε σφαγεισμένα υγρα δοχεία", "Σε σκοτεινό, ξηρό μέρος ή στους 35°C σε ξηραντήριο", "Με κατάψυξη και στη συνέχεια απόψυξη"],
  ),
];

// --- ROSEMARY QUIZ --- 7Questions
final rosemaryQuestions = [
  Question( // 1
    questionText: "Πότε φυτεύεται, συνήθως, το δενδρολίβανο στο χωράφι;",
    type: "multiple_choice",
    correctAnswer: "Το φθινόπωρο ή την άνοιξη, μετά τον κίνδυνο παγετού",
    options: ["Το φθινόπωρο ή την άνοιξη, μετά τον κίνδυνο παγετού", "Μόνο το καλοκαίρι κατά τη διάρκεια της έντονης ζέστης", "Το χειμώνα, ανεξάρτητα από τις συνθήκες παγετού", "Οποιαδήποτε στιγμή του χρόνου, χωρίς περιορισμούς"],
  ),
  Question( // 2
    questionText: "Πότε είναι η ιδανική περίοδος για τη συγκομιδή του δενδρολίβανου;",
    type: "multiple_choice",
    correctAnswer: "Στην αρχή της ανθοφορίας",
    options: ["Μετά το τέλος της πλήρους ανθοφορίας", "Πριν σχηματιστούν άνθη", "Στην αρχή της ανθοφορίας", "Μόνο κατά το χειμερινό λήθαργο"],
  ),
  Question( // 3
    questionText: "Τι είδους περιβάλλον προτιμά το δενδρολίβανο;",
    type: "multiple_choice",
    correctAnswer: "Ηλιόλουστα, ξηρά και θερμά περιβάλλοντα",
    options: ["Ηλιόλουστα, ξηρά και θερμά περιβάλλοντα", "ρύες, σκιερές και υγρές συνθήκες", "Συνθήκες χαμηλού φωτισμού σε εσωτερικό χώρο", "Τροπικές περιοχές με πολύ υψηλή υγρασία"],
  ),
  Question( // 4
    questionText: "Ποια είναι η σωστή μέθοδος για την αποξήρανση του δενδρολίβανου;",
    type: "multiple_choice",
    correctAnswer: "Κρέμασμα ανάποδα ή χρήση ξηραντηρίου κάτω από τους 40°C",
    options: ["Κρέμασμα ανάποδα ή χρήση ξηραντηρίου κάτω από τους 40°C", "Αποξήρανση σε άμεσο ηλιακό φως σε εξωτερικό χώρο", "Αποθήκευση σε σφραγισμένες πλαστικές σακούλες", "Μούλιασμα σε νερό πριν την αποξήρανση"],
  ),
  Question( // 5
    questionText: "What has a heart that doesn't beat?",
    type: "multiple_choice",
    correctAnswer: "An artichoke",
    options: ["A heart", "An artichoke", "A piano", "A kidney"],
  ),
  Question( // 6
    questionText: "What has a heart that doesn't beat?",
    type: "multiple_choice",
    correctAnswer: "An artichoke",
    options: ["A heart", "An artichoke", "A piano", "A kidney"],
  ),
  Question( // 7
    questionText: "What has a heart that doesn't beat?",
    type: "multiple_choice",
    correctAnswer: "An artichoke",
    options: ["A heart", "An artichoke", "A piano", "A kidney"],
  ),
];

// 2. Put them into the Quiz Bank
// This is what the TeacherView's ListView.builder looks at!
final List<Quiz> quizBank = [
  Quiz(
    id: "Oregano_Quiz",
    title: "Oregano Quiz",
    questions: oreganoQuestions,
  ),
  Quiz(
    id: "Sage_Quiz",
    title: "Sage Quiz",
    questions: sageQuestions,
  ),
  Quiz(
    id: "Dittany_Quiz",
    title: "Dittany Quiz",
    questions: dittanyQuestions,
  ),
];