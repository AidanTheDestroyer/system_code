import 'package:flutter/material.dart';

class CreateAssessmentPage extends StatefulWidget {
  const CreateAssessmentPage({super.key});

  @override
  State<CreateAssessmentPage> createState() => _CreateAssessmentPageState();
}

class _CreateAssessmentPageState extends State<CreateAssessmentPage> {
  static const Color stiNavy = Color(0xFF0D125A);
  static const Color bgColor = Color(0xFFF1F5F9);

  final _titleController = TextEditingController();
  final _durationController = TextEditingController();

  final List<Map<String, dynamic>> _questions = [];
  final List<TextEditingController> _questionTextControllers = [];
  final List<TextEditingController> _answerTextControllers = [];
  // Controller for Multiple Choice options
  final List<List<TextEditingController>> _optionControllers = [];

  final List<String> _quizTypes = [
    "Identification",
    "True or False",
    "Multiple Choice",
    "Crossword",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    for (var c in _questionTextControllers) {
      c.dispose();
    }
    for (var c in _answerTextControllers) {
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
      _questions.add({
        "type": "Identification",
        "text": "",
        "answer": "",
        "options": ["", "", "", ""], // Default 4 slots for Multiple Choice
      });
      _questionTextControllers.add(TextEditingController());
      _answerTextControllers.add(TextEditingController());
      _optionControllers.add(List.generate(4, (_) => TextEditingController()));
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      _questionTextControllers[index].dispose();
      _answerTextControllers[index].dispose();
      for (var c in _optionControllers[index]) {
        c.dispose();
      }

      _questionTextControllers.removeAt(index);
      _answerTextControllers.removeAt(index);
      _optionControllers.removeAt(index);
    });
  }

  void _submitAssessment() {
    if (_titleController.text.isEmpty || _durationController.text.isEmpty) {
      _showError("Please fill in the Title and Duration");
      return;
    }

    if (_questions.isEmpty) {
      _showError("Please add at least one question");
      return;
    }

    final Map<String, dynamic> newAssessment = {
      "title": _titleController.text.toUpperCase(),
      "duration": "${_durationController.text} min",
      "questions": _questions.length.toString(),
      "points": (_questions.length * 5).toString(),
      "due": "Just Now",
      "isArchived": false,
      "isGiven": false,
      "fullQuestionData": List.generate(
        _questions.length,
        (i) => {
          "type": _questions[i]['type'],
          "text": _questionTextControllers[i].text,
          "answer": _answerTextControllers[i].text,
          "options": _questions[i]['type'] == "Multiple Choice"
              ? _optionControllers[i].map((c) => c.text).toList()
              : [],
        },
      ),
    };

    Navigator.pop(context, newAssessment);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
          "CREATE NEW ASSESSMENT",
          style: TextStyle(
            color: stiNavy,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            fontFamily: 'serif',
          ),
        ),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          final isDesktop = MediaQuery.of(context).size.width > 600;

          Widget content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel("ASSESSMENT DETAILS"),
              const SizedBox(height: 15),
              _buildFormCard(),
              const SizedBox(height: 30),
              _buildSectionLabel("QUESTION BUILDER (${_questions.length})"),
              const SizedBox(height: 15),
              _questions.isEmpty
                  ? _buildEmptyQuestionPlaceholder()
                  : _buildQuestionList(),
              const SizedBox(height: 40),
              _buildActionButtons(),
            ],
          );

          return isDesktop
              // 💻 DESKTOP (unchanged behavior)
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: content,
                )
              // 📱 MOBILE (SafeArea applied)
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: content,
                  ),
                );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black45,
        letterSpacing: 1.1,
        fontSize: 12,
      ),
    );
  }

  Widget _buildFormCard() {
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
          _inputField(
            "Assessment Title",
            "e.g. Finals Quiz 1",
            _titleController,
            Icons.title,
            isNumeric: false,
          ),
          const SizedBox(height: 20),
          _inputField(
            "Duration (Mins)",
            "30",
            _durationController,
            Icons.timer_outlined,
            isNumeric: true,
          ),
        ],
      ),
    );
  }

  Widget _inputField(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    required bool isNumeric,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: stiNavy, size: 20),
            hintText: hint,
            filled: true,
            fillColor: bgColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionList() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _questions.length,
          itemBuilder: (context, index) => _buildQuestionCard(index),
        ),
        const SizedBox(height: 15),
        TextButton.icon(
          onPressed: _addNewQuestion,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text("ADD ANOTHER QUESTION"),
          style: TextButton.styleFrom(foregroundColor: stiNavy),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index) {
    String selectedType = _questions[index]['type'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5),
        ],
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
                        setState(() => _questions[index]['type'] = val),
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
            controller: _questionTextControllers[index],
            decoration: const InputDecoration(
              hintText: "Enter question prompt...",
              hintStyle: TextStyle(fontSize: 14, color: Colors.black26),
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
              controller: _answerTextControllers[index],
              decoration: InputDecoration(
                hintText: selectedType == "Multiple Choice"
                    ? "Enter the exact text of correct choice"
                    : "Enter correct answer",
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black26),
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
    bool isSelected = _answerTextControllers[index].text == label;
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
          setState(() => _answerTextControllers[index].text = label),
    );
  }

  Widget _buildEmptyQuestionPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 50,
            color: stiNavy.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 10),
          const Text(
            "Choose a quiz type to begin.",
            style: TextStyle(color: Colors.black26, fontSize: 14),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _addNewQuestion,
            icon: const Icon(Icons.add),
            label: const Text("START BUILDING"),
            style: ElevatedButton.styleFrom(
              backgroundColor: stiNavy,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    if (!isDesktop) {
      final bottomInset = MediaQuery.of(context).viewPadding.bottom;

      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset + 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _submitAssessment,
              style: ElevatedButton.styleFrom(
                backgroundColor: stiNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "PUBLISH ASSESSMENT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: _submitAssessment,
            style: ElevatedButton.styleFrom(
              backgroundColor: stiNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "PUBLISH ASSESSMENT",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
