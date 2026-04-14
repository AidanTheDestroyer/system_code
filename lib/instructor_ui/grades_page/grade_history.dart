import 'package:flutter/material.dart';
import '../notification_page/notification.dart';

class GradesManagementPage extends StatefulWidget {
  final String subjectCode;
  final String subjectName;

  const GradesManagementPage({
    super.key,
    required this.subjectCode,
    required this.subjectName,
  });

  @override
  State<GradesManagementPage> createState() => _GradesManagementPageState();
}

class _GradesManagementPageState extends State<GradesManagementPage> {
  static const Color stiNavy = Color(0xFF000080);
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color tableHeaderColor = Color(0xFFF1F5F9);
  static const Color progressGreen = Color(0xFFE8F5E9);
  static const Color progressText = Color(0xFF2E7D32);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedDate = "03/09/26";

  final List<Map<String, dynamic>> _allGrades = [
    {
      "name": "Garcia, Maria",
      "q1": "20/20",
      "q2": "12/15",
      "q3": "24/25",
      "points": "6870 pts",
      "progress": "87%",
      "date": "03/09/26",
    },
    {
      "name": "Hinks, Jet",
      "q1": "14/20",
      "q2": "12/15",
      "q3": "15/25",
      "points": "5780 pts",
      "progress": "85%",
      "date": "03/09/26",
    },
    {
      "name": "Hugh, Tony",
      "q1": "16/20",
      "q2": "13/15",
      "q3": "16/25",
      "points": "5270 pts",
      "progress": "83%",
      "date": "03/10/26",
    },
    {
      "name": "Johnson, Alex",
      "q1": "19/20",
      "q2": "8/15",
      "q3": "7/25",
      "points": "8340 pts",
      "progress": "86%",
      "date": "03/09/26",
    },
    {
      "name": "Labrusco, Pacita",
      "q1": "12/20",
      "q2": "15/15",
      "q3": "25/25",
      "points": "2570 pts",
      "progress": "89%",
      "date": "03/11/26",
    },
    {
      "name": "Pru, Sam",
      "q1": "14/20",
      "q2": "15/15",
      "q3": "14/25",
      "points": "4790 pts",
      "progress": "84%",
      "date": "03/10/26",
    },
    {
      "name": "Sy, Andrea",
      "q1": "10/20",
      "q2": "10/15",
      "q3": "18/25",
      "points": "3840 pts",
      "progress": "81%",
      "date": "03/09/26",
    },
  ];

  List<Map<String, dynamic>> _filteredGrades = [];

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredGrades = _allGrades.where((item) {
        final matchesName = item['name'].toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        final matchesDate = item['date'] == _selectedDate;
        return matchesName && matchesDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    return Material(
      color: bgColor,
      child: Column(
        children: [
          _buildStandardHeader("${widget.subjectCode} Grades", isDesktop),
          _buildFilterHeader(isDesktop),
          _buildActionRow(isDesktop),
          Expanded(
            child: isDesktop ? _buildTableCard() : _buildPhoneCardList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardHeader(String title, bool isDesktop) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: stiNavy,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                fontFamily: 'serif',
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

  Widget _buildFilterHeader(bool isDesktop) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 32 : 16,
        24,
        isDesktop ? 32 : 16,
        12,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CURRENT SUBJECT: ${widget.subjectName}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.grey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _searchQuery = value;
                      _applyFilters();
                    },
                    decoration: const InputDecoration(
                      hintText: "Search Student Name...",
                      prefixIcon: Icon(Icons.search, size: 20, color: stiNavy),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (isDesktop)
                const Text(
                  "Date Filter",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              if (isDesktop) const SizedBox(width: 12),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDate,
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: stiNavy,
                    ),
                    items: ["03/09/26", "03/10/26", "03/11/26"].map((
                      String date,
                    ) {
                      return DropdownMenuItem(
                        value: date,
                        child: Text(date, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedDate = newValue);
                        _applyFilters();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 12,
      ),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Summary stats
          Row(
            children: [
              _miniStat(
                "Total",
                "${_filteredGrades.length}",
                Icons.people_outline,
              ),
              const SizedBox(width: 16),
              _miniStat(
                "Avg Progress",
                _filteredGrades.isEmpty
                    ? "—"
                    : "${(_filteredGrades.map((g) => int.parse((g['progress'] as String).replaceAll('%', ''))).reduce((a, b) => a + b) / _filteredGrades.length).toStringAsFixed(0)}%",
                Icons.trending_up,
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _showExportDialog(),
            icon: const Icon(
              Icons.file_download_outlined,
              size: 18,
              color: Colors.white,
            ),
            label: Text(
              isDesktop ? "EXPORT REPORT" : "EXPORT",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: stiNavy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: stiNavy),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: stiNavy,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 2500)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(
                      color: stiNavy,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "GENERATING REPORT",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: stiNavy,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Compiling grade history...",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "DOWNLOAD COMPLETE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: stiNavy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Grade report saved locally.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: stiNavy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "CLOSE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }

  // ── DESKTOP: full table with all six columns ─────────────────────────────

  Widget _buildTableCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(32, 10, 32, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: const BoxDecoration(
              color: tableHeaderColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                _cell("STUDENT NAME", flex: 3, isHeader: true),
                _cell("QUIZ 1", flex: 2, isHeader: true),
                _cell("QUIZ 2", flex: 2, isHeader: true),
                _cell("QUIZ 3", flex: 2, isHeader: true),
                _cell("POINTS", flex: 3, isHeader: true),
                _cell("PROGRESS", flex: 2, isHeader: true),
              ],
            ),
          ),
          Expanded(
            child: _filteredGrades.isEmpty
                ? const Center(
                    child: Text(
                      "No records found.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredGrades.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (ctx, i) => SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          _cell(_filteredGrades[i]["name"], flex: 3),
                          _cell(_filteredGrades[i]["q1"], flex: 2),
                          _cell(_filteredGrades[i]["q2"], flex: 2),
                          _cell(_filteredGrades[i]["q3"], flex: 2),
                          _cell(_filteredGrades[i]["points"], flex: 3),
                          _progressBadge(
                            _filteredGrades[i]["progress"],
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── PHONE: card list — one card per student ───────────────────────────────

  Widget _buildPhoneCardList() {
    if (_filteredGrades.isEmpty) {
      return const Center(
        child: Text("No records found.", style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: _filteredGrades.length,
      itemBuilder: (ctx, i) => _buildPhoneGradeCard(_filteredGrades[i]),
    );
  }

  Widget _buildPhoneGradeCard(Map<String, dynamic> grade) {
    final progress =
        int.tryParse((grade['progress'] as String).replaceAll('%', '')) ?? 0;
    final progressColor = progress >= 88
        ? const Color(0xFF2E7D32)
        : progress >= 84
        ? const Color(0xFF1565C0)
        : const Color(0xFF6A1B9A);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student name + progress badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  grade['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: stiNavy,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  grade['progress'],
                  style: TextStyle(
                    color: progressColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 12),
          // Quiz scores row
          Row(
            children: [
              _quizChip("Quiz 1", grade['q1']),
              const SizedBox(width: 8),
              _quizChip("Quiz 2", grade['q2']),
              const SizedBox(width: 8),
              _quizChip("Quiz 3", grade['q3']),
              const Spacer(),
              // Points
              Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    size: 14,
                    color: Color(0xFFFFC72C),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    grade['points'],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: stiNavy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quizChip(String label, String score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tableHeaderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: stiNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String? text, {required int flex, bool isHeader = false}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isHeader ? 10 : 12,
            fontWeight: isHeader ? FontWeight.w900 : FontWeight.normal,
            color: isHeader ? stiNavy : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _progressBadge(String value, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: progressGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: progressText,
              fontWeight: FontWeight.w900,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
