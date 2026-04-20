import 'package:flutter/material.dart';
import '../notification_page/notification.dart';
import 'edit_assessment.dart';
import 'create_assessment.dart';

class AssessmentHubPage extends StatefulWidget {
  const AssessmentHubPage({super.key});

  @override
  State<AssessmentHubPage> createState() => _AssessmentHubPageState();
}

class _AssessmentHubPageState extends State<AssessmentHubPage> {
  static const Color stiNavy = Color(0xFF0D125A);
  static const Color bgColor = Color(0xFFF1F5F9);

  final TextEditingController _searchController = TextEditingController();

  bool isTasksSelected = true;
  String _searchQuery = "";

  final List<Map<String, dynamic>> _allQuizzes = [
    {
      "title": "QUIZ 3: GRAPH ALGORITHMS",
      "duration": "15 min",
      "questions": "20",
      "points": "40",
      "due": "03/09/26",
      "isArchived": false,
      "isGiven": false,
    },
    {
      "title": "QUIZ 4: RECURSION",
      "duration": "30 min",
      "questions": "15",
      "points": "25",
      "due": "03/11/26",
      "isArchived": false,
      "isGiven": true,
    },
    {
      "title": "QUIZ 2: BINARY TREES",
      "duration": "45 min",
      "questions": "35",
      "points": "50",
      "due": "03/08/26",
      "isArchived": false,
      "isGiven": false,
    },
    {
      "title": "QUIZ 1: ALGO TYPES",
      "duration": "10 min",
      "questions": "10",
      "points": "15",
      "due": "03/08/26",
      "isArchived": true,
      "isGiven": false,
    },
  ];

  List<Map<String, dynamic>> get _filteredQuizzes {
    return _allQuizzes.where((quiz) {
      bool matchesStatus = quiz['isArchived'] == !isTasksSelected;
      bool matchesSearch = quiz['title'].toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesStatus && matchesSearch;
    }).toList();
  }

  void _toggleQuizStatus(Map<String, dynamic> quiz) {
    setState(() {
      quiz['isGiven'] = !quiz['isGiven'];
    });
    final String message = quiz['isGiven']
        ? "Quiz published to students."
        : "Quiz retracted successfully.";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: quiz['isGiven'] ? Colors.green : stiNavy,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _navigateAndAddAssessment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAssessmentPage()),
    );
    if (!mounted) return;
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        result['isGiven'] = false;
        _allQuizzes.insert(0, result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New assessment published!")),
      );
    }
  }

  Future<void> _navigateAndEditAssessment(Map<String, dynamic> quiz) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAssessmentPage(quizData: quiz),
      ),
    );
    if (!mounted) return;
    if (result == "DELETE_SIGNAL") {
      setState(() => _allQuizzes.remove(quiz));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Assessment deleted successfully")),
      );
    } else if (result != null) {
      setState(() {
        int index = _allQuizzes.indexOf(quiz);
        if (index != -1) _allQuizzes[index] = result;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    return Material(
      color: bgColor,
      child: Column(
        children: [
          _buildHeader(isDesktop),
          _buildActionBar(isDesktop),
          Expanded(
            child: _filteredQuizzes.isEmpty
                ? const Center(
                    child: Text(
                      "No assessments found.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxis = constraints.maxWidth > 600 ? 2 : 1;
                      final aspectRatio = constraints.maxWidth > 600
                          ? 1.5
                          : 2.2;
                      return GridView.builder(
                        padding: EdgeInsets.all(isDesktop ? 30 : 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxis,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: _filteredQuizzes.length,
                        itemBuilder: (context, index) =>
                            _buildQuizCard(_filteredQuizzes[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 30 : 16,
        vertical: isDesktop ? 20 : 14,
      ),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "ASSESSMENT HUB",
              style: TextStyle(
                fontSize: isDesktop ? 24 : 18,
                fontWeight: FontWeight.w900,
                fontFamily: 'serif',
                color: stiNavy,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: stiNavy),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 35 : 16,
        vertical: isDesktop ? 20 : 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search assessments...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _navigateAndAddAssessment,
                icon: const Icon(Icons.add, size: 18),
                label: Text(isDesktop ? "NEW ASSESSMENT" : "NEW"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: stiNavy,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 20 : 12,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _toggleBtn(
                "TASKS",
                isTasksSelected,
                () => setState(() => isTasksSelected = true),
              ),
              const SizedBox(width: 10),
              _toggleBtn(
                "ARCHIVED",
                !isTasksSelected,
                () => setState(() => isTasksSelected = false),
              ),
              const Spacer(),
              // Summary count badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: stiNavy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_filteredQuizzes.length} item${_filteredQuizzes.length != 1 ? 's' : ''}",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: stiNavy,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback tap) {
    return OutlinedButton(
      onPressed: tap,
      style: OutlinedButton.styleFrom(
        backgroundColor: active ? stiNavy : Colors.white,
        foregroundColor: active ? Colors.white : stiNavy,
        side: const BorderSide(color: stiNavy),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> quiz) {
    final bool isGiven = quiz['isGiven'] ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isGiven
              ? Colors.green.withValues(alpha: 0.5)
              : Colors.black.withValues(alpha: 0.05),
          width: isGiven ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  quiz['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                    color: stiNavy,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => _navigateAndEditAssessment(quiz),
                child: const Icon(
                  Icons.edit_note,
                  color: Colors.black38,
                  size: 20,
                ),
              ),
            ],
          ),
          const Divider(height: 12),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 12, color: Colors.black38),
              const SizedBox(width: 4),
              Text(
                quiz['duration'],
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.help_outline, size: 12, color: Colors.black38),
              const SizedBox(width: 4),
              Text(
                "${quiz['questions']} Qs",
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _toggleQuizStatus(quiz),
              style: ElevatedButton.styleFrom(
                backgroundColor: isGiven ? Colors.redAccent : stiNavy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(
                isGiven ? "UNGIVE QUIZ" : "GIVE QUIZ",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
