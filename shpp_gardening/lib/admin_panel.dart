import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Πίνακας Moderator"),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.quiz), text: "Νέο Κουίζ"),
            Tab(icon: Icon(Icons.eco), text: "Νέο Φυτό"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _QuizCreatorTab(),
          _PlantCreatorTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// TAB 1 — QUIZ CREATOR
// ─────────────────────────────────────────
class _QuizCreatorTab extends StatefulWidget {
  const _QuizCreatorTab();

  @override
  State<_QuizCreatorTab> createState() => _QuizCreatorTabState();
}

class _QuizCreatorTabState extends State<_QuizCreatorTab> {
  final _titleController = TextEditingController();
  final List<_QuestionDraft> _questions = [];
  bool _isSaving = false;

  void _addQuestion() {
    setState(() => _questions.add(_QuestionDraft()));
  }

  void _removeQuestion(int index) {
    setState(() => _questions.removeAt(index));
  }

  Future<void> _saveQuiz() async {
    if (_titleController.text.trim().isEmpty) {
      _snack("Παρακαλώ δώσε τίτλο στο κουίζ.");
      return;
    }
    if (_questions.isEmpty) {
      _snack("Πρόσθεσε τουλάχιστον μία ερώτηση.");
      return;
    }
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      if (q.questionController.text.trim().isEmpty || q.answerController.text.trim().isEmpty) {
        _snack("Η ερώτηση ${i + 1} είναι ελλιπής.");
        return;
      }
      if (q.type == 'multiple_choice') {
        final filled = q.optionControllers.where((c) => c.text.trim().isNotEmpty).length;
        if (filled < 2) {
          _snack("Η ερώτηση ${i + 1} χρειάζεται τουλάχιστον 2 επιλογές.");
          return;
        }
      }
    }

    setState(() => _isSaving = true);

    final serialized = _questions.map((q) {
      return {
        'questionText': q.questionController.text.trim(),
        'type': q.type,
        'correctAnswer': q.answerController.text.trim(),
        'options': q.type == 'multiple_choice'
            ? q.optionControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList()
            : [],
      };
    }).toList();

    await FirebaseFirestore.instance.collection('globalQuizBank').add({
      'title': _titleController.text.trim(),
      'questions': serialized,
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isSaving = false;
      _titleController.clear();
      _questions.clear();
    });
    _snack("Το κουίζ αποθηκεύτηκε στην τράπεζα!");
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: "Τίτλος Κουίζ",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 16),
          ..._questions.asMap().entries.map((entry) {
            final i = entry.key;
            final q = entry.value;
            return _QuestionCard(
              index: i,
              draft: q,
              onRemove: () => _removeQuestion(i),
              onChanged: () => setState(() {}),
            );
          }),
          OutlinedButton.icon(
            onPressed: _addQuestion,
            icon: const Icon(Icons.add),
            label: const Text("Προσθήκη Ερώτησης"),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _saveQuiz,
        backgroundColor: Colors.green.shade700,
        icon: _isSaving
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.cloud_upload, color: Colors.white),
        label: Text(_isSaving ? "Αποθήκευση..." : "Δημοσίευση Κουίζ",
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────
// QUESTION DRAFT MODEL
// ─────────────────────────────────────────
class _QuestionDraft {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(4, (_) => TextEditingController());
  String type = 'multiple_choice';
}

class _QuestionCard extends StatefulWidget {
  final int index;
  final _QuestionDraft draft;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const _QuestionCard({
    required this.index,
    required this.draft,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  @override
  Widget build(BuildContext context) {
    final d = widget.draft;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ερώτηση ${widget.index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'multiple_choice', label: Text("Πολλαπλής"), icon: Icon(Icons.list)),
                ButtonSegment(value: 'riddle', label: Text("Γρίφος"), icon: Icon(Icons.help_outline)),
              ],
              selected: {d.type},
              onSelectionChanged: (s) => setState(() => d.type = s.first),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: d.questionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Κείμενο ερώτησης",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: d.answerController,
              decoration: const InputDecoration(
                labelText: "Σωστή απάντηση",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.check_circle_outline, color: Colors.green),
              ),
            ),
            if (d.type == 'multiple_choice') ...[
              const SizedBox(height: 12),
              const Text("Επιλογές (τουλάχιστον 2):",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              ...d.optionControllers.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: e.value,
                      decoration: InputDecoration(
                        labelText: "Επιλογή ${e.key + 1}",
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// TAB 2 — PLANT CREATOR
// ─────────────────────────────────────────
class _PlantCreatorTab extends StatefulWidget {
  const _PlantCreatorTab();

  @override
  State<_PlantCreatorTab> createState() => _PlantCreatorTabState();
}

class _PlantCreatorTabState extends State<_PlantCreatorTab> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _howToController = TextEditingController();
  bool _isSaving = false;

  Uint8List? _imageBytes;
  String? _imageFileName;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _imageFileName = picked.name;
    });
  }

  Future<String?> _uploadImage(String plantName) async {
    if (_imageBytes == null) return null;
    final ext = _imageFileName?.split('.').last ?? 'jpg';
    final ref = FirebaseStorage.instance
        .ref()
        .child('plant_images/${plantName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref.putData(_imageBytes!, SettableMetadata(contentType: 'image/$ext'));
    return await ref.getDownloadURL();
  }

  Future<void> _savePlant() async {
    if (_nameController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _howToController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Παρακαλώ συμπλήρωσε όλα τα υποχρεωτικά πεδία.")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final plantName = _nameController.text.trim();
    final imageUrl = await _uploadImage(plantName);

    await FirebaseFirestore.instance.collection('plants').add({
      'name': plantName,
      'category': _categoryController.text.trim().isEmpty ? 'Αρωματικά' : _categoryController.text.trim(),
      'description': _descriptionController.text.trim(),
      'howTo': _howToController.text.trim(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isSaving = false;
      _nameController.clear();
      _categoryController.clear();
      _descriptionController.clear();
      _howToController.clear();
      _imageBytes = null;
      _imageFileName = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Το φυτό προστέθηκε και εμφανίζεται τώρα στην εφαρμογή!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Νέα κάρτα φυτού",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text(
          "Το φυτό θα εμφανιστεί αμέσως στην οθόνη Πληροφοριών για όλους τους χρήστες.",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),

        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Όνομα φυτού *",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.eco),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: _categoryController,
          decoration: const InputDecoration(
            labelText: "Κατηγορία (προεπιλογή: Αρωματικά)",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: "Περιγραφή *",
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: _howToController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: "Οδηγίες φροντίδας *",
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),

        // --- IMAGE PICKER ---
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green.shade300, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.green.shade50,
            ),
            child: _imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(_imageBytes!, fit: BoxFit.cover, width: double.infinity),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 48, color: Colors.green.shade400),
                      const SizedBox(height: 8),
                      Text("Πατήστε για επιλογή εικόνας (προαιρετικό)",
                          style: TextStyle(color: Colors.green.shade600)),
                    ],
                  ),
          ),
        ),
        if (_imageBytes != null) ...[
          const SizedBox(height: 6),
          TextButton.icon(
            onPressed: () => setState(() {
              _imageBytes = null;
              _imageFileName = null;
            }),
            icon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
            label: const Text("Αφαίρεση εικόνας", style: TextStyle(color: Colors.redAccent)),
          ),
        ],

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _savePlant,
            icon: _isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.cloud_upload),
            label: Text(_isSaving ? "Αποθήκευση..." : "Δημοσίευση φυτού"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),

        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 12),

        const Text("Φυτά στη βάση δεδομένων",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('plants')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            if (snap.data!.docs.isEmpty) {
              return const Text("Δεν έχουν προστεθεί φυτά ακόμα.",
                  style: TextStyle(color: Colors.grey));
            }
            return Column(
              children: snap.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  leading: data['imageUrl'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(data['imageUrl'],
                              width: 40, height: 40, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.local_florist, color: Colors.green),
                  title: Text(data['name'] ?? ''),
                  subtitle: Text(data['category'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => doc.reference.delete(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _howToController.dispose();
    super.dispose();
  }
}