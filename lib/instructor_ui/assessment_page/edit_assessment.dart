import 'package:flutter/material.dart';

class EditAssessmentPage extends StatefulWidget {
  final Map<String, dynamic> quizData;

  const EditAssessmentPage({super.key, required this.quizData});

  @override
  State<EditAssessmentPage> createState() => _EditAssessmentPageState();
}

class _EditAssessmentPageState extends State<EditAssessmentPage> {
  late TextEditingController _titleController;
  late TextEditingController _durationController;

  final List<Map<String, dynamic>> _questions = [];
  final List<TextEditingController> _questionControllers = [];
  final List<TextEditingController> _answerControllers = [];

  // ADDED: List to hold multiple choice option controllers
  final List<List<TextEditingController>> _optionControllers = [];

  static const Color stiNavy = Color(0xFF0D125A);
  static const Color bgColor = Color(0xFFF1F5F9);

  final List<String> _quizTypes = [
    "Identification",
    "True or False",
    "Multiple Choice",
    "Crossword",
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quizData['title']);

    // Sanitize duration for display
    String duration = widget.quizData['duration'].toString().replaceAll(
      " min",
      "",
    );
    _durationController = TextEditingController(text: duration);

    final List<dynamic> existingQuestions =
        widget.quizData['fullQuestionData'] ?? [];
    _initializeQuestions(existingQuestions);
  }

  void _initializeQuestions(List<dynamic> initialData) {
    for (var q in initialData) {
      _questions.add({
        "type": q['type'] ?? "Identification",
        "text": q['text'] ?? "",
        "answer": q['answer'] ?? "",
      });

      _questionControllers.add(TextEditingController(text: q['text']));
      _answerControllers.add(TextEditingController(text: q['answer']));

      // Initialize 4 options for each existing question
      List<dynamic> options = q['options'] ?? ["", "", "", ""];
      _optionControllers.add(
        List.generate(
          4,
          (i) => TextEditingController(
            text: i < options.length ? options[i].toString() : "",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    for (var c in _questionControllers) {
      c.dispose();
    }
    for (var c in _answerControllers) {
      c.dispose();
    }
    for (var list in _optionControllers) {
      for (var c in list) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _addNewQuestion() {
    setState(() {
      _questions.add({"type": "Identification", "text": "", "answer": ""});
      _questionControllers.add(TextEditingController());
      _answerControllers.add(TextEditingController());
      _optionControllers.add(List.generate(4, (_) => TextEditingController()));
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      _questionControllers[index].dispose();
      _answerControllers[index].dispose();
      for (var c in _optionControllers[index]) {
        c.dispose();
      }

      _questionControllers.removeAt(index);
      _answerControllers.removeAt(index);
      _optionControllers.removeAt(index);
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                "Delete Assessment?",
                style: TextStyle(fontWeight: FontWeight.bold, color: stiNavy),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this assessment? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, "DELETE_SIGNAL");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                "DELETE PERMANENTLY",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveAllChanges() {
    if (_titleController.text.isEmpty || _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and Duration are required")),
      );
      return;
    }

    setState(() {
      widget.quizData['title'] = _titleController.text.toUpperCase();
      widget.quizData['duration'] = "${_durationController.text} min";
      widget.quizData['questions'] = _questions.length.toString();
      widget.quizData['points'] = (_questions.length * 5).toString();

      widget.quizData['fullQuestionData'] = List.generate(
        _questions.length,
        (i) => {
          "type": _questions[i]['type'],
          "text": _questionControllers[i].text,
          "answer": _answerControllers[i].text,
          "options": _questions[i]['type'] == "Multiple Choice"
              ? _optionControllers[i].map((c) => c.text).toList()
              : [],
        },
      );
    });

    Navigator.pop(context, widget.quizData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: stiNavy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "EDIT ASSESSMENT",
          style: TextStyle(
            color: stiNavy,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            fontFamily: 'serif',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _saveAllChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                elevation: 0,
              ),
              child: const Text(
                "SAVE CHANGES",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width > 600 ? 30 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("GENERAL SETTINGS"),
            _buildSettingsCard(),
            const SizedBox(height: 30),
            _buildSectionHeader("QUESTION EDITOR (${_questions.length})"),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) => _buildQuestionCard(index),
            ),
            const SizedBox(height: 20),
            _buildAddButton(),
            const SizedBox(height: 60),
            _buildDeleteButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black45,
        letterSpacing: 1.1,
        fontSize: 12,
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _editField("Assessment Title", _titleController, Icons.title),
          const SizedBox(height: 20),
          _editField(
            "Duration (Mins)",
            _durationController,
            Icons.timer_outlined,
          ),
        ],
      ),
    );
  }

  Widget _editField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: stiNavy, size: 20),
        filled: true,
        fillColor: bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    String selectedType = _questions[index]['type'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedType,
                    style: const TextStyle(
                      color: stiNavy,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    items: _quizTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _questions[index]['type'] = val!),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () => _removeQuestion(index),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _questionControllers[index],
            maxLines: 2,
            decoration: InputDecoration(
              hintText: selectedType == "Multiplication"
                  ? "Enter equation (e.g. 5 x 5)"
                  : "Enter question text...",
              border: InputBorder.none,
            ),
          ),
          const Divider(height: 30),

          // --- CONDITIONAL UI FOR MULTIPLE CHOICE ---
          if (selectedType == "Multiple Choice") ...[
            const Text(
              "OPTIONS",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _optionControllers[index][i],
                  decoration: InputDecoration(
                    hintText: "Choice ${String.fromCharCode(65 + i)}",
                    prefixIcon: const Icon(Icons.radio_button_off, size: 16),
                    filled: true,
                    fillColor: bgColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),
            const SizedBox(height: 10),
          ],

          // --- DYNAMIC CORRECT ANSWER FIELD ---
          if (selectedType == "True or False")
            Row(
              children: [
                const Text(
                  "Correct Answer:",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 15),
                _answerToggleChip(index, "True"),
                const SizedBox(width: 10),
                _answerToggleChip(index, "False"),
              ],
            )
          else
            TextField(
              controller: _answerControllers[index],
              decoration: InputDecoration(
                hintText: selectedType == "Crossword"
                    ? "Enter keyword"
                    : "Enter correct answer",
                prefixIcon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 18,
                ),
                border: InputBorder.none,
              ),
            ),
        ],
      ),
    );
  }

  Widget _answerToggleChip(int index, String label) {
    bool isSelected = _answerControllers[index].text == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : stiNavy,
          fontSize: 11,
        ),
      ),
      selected: isSelected,
      selectedColor: stiNavy,
      onSelected: (val) =>
          setState(() => _answerControllers[index].text = label),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addNewQuestion,
        icon: const Icon(Icons.add),
        label: const Text("ADD NEW QUESTION"),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          side: const BorderSide(color: stiNavy, width: 1.5),
          foregroundColor: stiNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: _confirmDelete,
        icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
        label: const Text(
          "DELETE THIS ASSESSMENT",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
