import 'quiz_model.dart'; // Ensure this matches your model filename





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





///////////////////////////////////////////////////////////////////////////////


// --- OREGANO QUIZ ---
final oreganoQuestions = [
  Question( 
    questionText: "I am a plant that loves to sunbathe all day. I smell very sweet and I am the perfect plant to start your garden",
    type: "riddle",
    correctAnswer: "Oregano",
  ),
  Question(
    questionText: "How much water does oregano need to grow?",
    type: "multiple_choice",
    correctAnswer: "Not much, it likes to stay dry",
    options: ["A bucket a day", "Not much, it likes to stay dry", "It needs to be underwater with the fish", "It only drinks chocolate milk"],
  ),
  Question(
    questionText: "where is the best place to grow your orgeano?",
    type: "multiple_choice",
    correctAnswer: "In a sunny spot",
    options: ["In a dark closet", "In a sunny spot", "In the fridge", "In the bathroom"],
  ),
  Question(
    questionText: "what can you do with the leaves and flowers of oregano?",
    type: "multiple_choice",
    correctAnswer: "You can make seasoning",
    options: ["You can make seasoning", "You can make medicine", "You can make a scrambled eggs", "You can make a cake"],
  )
];


// --- MINT QUIZ ---
final mintQuestions = [
  Question(
    questionText: "I am a plant that is known for its refreshing scent and is often used in teas. What am I?",
    type: "riddle",
    correctAnswer: "Mint",
    options: ["Basil", "Oregano", "Mint", "Thyme"],
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
  
];