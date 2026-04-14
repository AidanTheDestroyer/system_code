import 'package:flutter/material.dart';
import '../notification_page/notification.dart';

class InstructorDashboard extends StatefulWidget {
  final String subjectCode;
  final String subjectName;
  final Map<String, dynamic> courseData;

  const InstructorDashboard({
    super.key,
    required this.subjectCode,
    required this.subjectName,
    required this.courseData,
  });

  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  static const Color darkNavy = Color(0xFF0D125A);
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color accentRed = Color(0xFFE53935);
  static const Color accentGold = Color(0xFFFFC72C);

  bool _isActivated = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredStudents = [];

  final String _attendancePercentage = "75%";
  final String _presentCount = "15/20 Present";
  final double _classAverage = 88.5;

  // Mock per-student attendance status for richer roster display
  final Map<String, String> _studentStatus = {
    "Amigo, Raphael": "Present",
    "Brusco, Hannah": "Late",
    "Fabrino, Valerie": "Present",
    "Dela Cruz, Juan": "Absent",
    "Garcia, Maria": "Present",
    "Johnson, Alex": "Present",
    "Lopez, Chris": "Late",
    "Tan, Kevin": "Absent",
    "Reyes, Mika": "Present",
  };

  @override
  void initState() {
    super.initState();
    _filteredStudents = widget.courseData['students'] ?? [];
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredStudents = (widget.courseData['students'] as List<dynamic>)
          .where(
            (student) =>
                student.toString().toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  Color _statusColor(String name) {
    final status = _studentStatus[name] ?? "Absent";
    switch (status) {
      case "Present":
        return accentGreen;
      case "Late":
        return accentGold;
      default:
        return accentRed;
    }
  }

  String _statusLabel(String name) => _studentStatus[name] ?? "Absent";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      child: Column(
        children: [
          _buildMinimalHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 600;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 16,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Session status banner
                      _buildSessionBanner(isDesktop),
                      const SizedBox(height: 20),

                      // Stat cards
                      if (isDesktop)
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                "Total Attendance",
                                _attendancePercentage,
                                _presentCount,
                                accentGreen,
                                Icons.how_to_reg_rounded,
                                0.75,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                "Class Average",
                                "${_classAverage.toInt()}%",
                                "Grade: A-",
                                Colors.purple,
                                Icons.bar_chart_rounded,
                                0.885,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                "Students Present",
                                "15",
                                "5 absent or late",
                                darkNavy,
                                Icons.people_rounded,
                                0.75,
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    "Attendance",
                                    _attendancePercentage,
                                    _presentCount,
                                    accentGreen,
                                    Icons.how_to_reg_rounded,
                                    0.75,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    "Class Avg",
                                    "${_classAverage.toInt()}%",
                                    "Grade: A-",
                                    Colors.purple,
                                    Icons.bar_chart_rounded,
                                    0.885,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildStatCard(
                              "Students Present",
                              "15 / 20",
                              "5 absent or late",
                              darkNavy,
                              Icons.people_rounded,
                              0.75,
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),

                      // Roster + activation
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildRosterCard(isDesktop),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildActivationCard(),
                                  const SizedBox(height: 16),
                                  _buildQuickActions(isDesktop),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildRosterCard(isDesktop),
                            const SizedBox(height: 16),
                            _buildActivationCard(),
                            const SizedBox(height: 16),
                            _buildQuickActions(isDesktop),
                          ],
                        ),

                      const SizedBox(height: 20),
                      _buildBottomActions(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalHeader() {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Text(
                  "Courses",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.subjectName.toUpperCase(),
                    style: const TextStyle(
                      color: darkNavy,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      fontFamily: 'serif',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: darkNavy,
              size: 24,
            ),
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

  // Session status banner — tells teacher what state the class is in
  Widget _buildSessionBanner(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: _isActivated
            ? accentGreen.withValues(alpha: 0.08)
            : darkNavy.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isActivated
              ? accentGreen.withValues(alpha: 0.3)
              : darkNavy.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _isActivated ? accentGreen : Colors.grey,
              shape: BoxShape.circle,
              boxShadow: _isActivated
                  ? [
                      BoxShadow(
                        color: accentGreen.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isActivated
                      ? "CLASS SESSION IS LIVE"
                      : "CLASS SESSION IS INACTIVE",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: _isActivated ? accentGreen : Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  _isActivated
                      ? "${widget.subjectCode} · Students can now log in"
                      : "Press ACTIVATE to start the session",
                  style: TextStyle(
                    fontSize: 11,
                    color: _isActivated
                        ? accentGreen.withValues(alpha: 0.7)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (_isActivated)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "LIVE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Enhanced stat card with progress bar
  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  // Roster card with per-student status dots
  Widget _buildRosterCard(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CLASS ROSTER",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: darkNavy,
                ),
              ),
              // Legend
              Row(
                children: [
                  _dot(accentGreen),
                  const SizedBox(width: 3),
                  const Text(
                    "Present",
                    style: TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  _dot(accentGold),
                  const SizedBox(width: 3),
                  const Text(
                    "Late",
                    style: TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  _dot(accentRed),
                  const SizedBox(width: 3),
                  const Text(
                    "Absent",
                    style: TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Search bar
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Search student...",
                hintStyle: TextStyle(fontSize: 12),
                prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Student grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: isDesktop ? 1.2 : 1.0,
            ),
            itemCount: _filteredStudents.length,
            itemBuilder: (ctx, i) {
              final name = _filteredStudents[i].toString();
              final color = _statusColor(name);
              final firstName = name.contains(',')
                  ? name.split(',')[0].trim()
                  : name.split(' ')[0];
              return Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: isDesktop ? 18 : 16,
                          backgroundColor: color.withValues(alpha: 0.15),
                          child: Icon(
                            Icons.person,
                            color: color,
                            size: isDesktop ? 18 : 16,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        firstName,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: darkNavy,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _statusLabel(name),
                      style: TextStyle(
                        fontSize: 8,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  // Activation card with more visual feedback
  Widget _buildActivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
          ),
        ],
        border: Border.all(
          color: _isActivated
              ? accentGreen.withValues(alpha: 0.4)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "HOTSPOT STATUS",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 11,
              color: darkNavy,
            ),
          ),
          const SizedBox(height: 16),
          // Animated status indicator
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (_isActivated ? accentGreen : Colors.grey).withValues(
                alpha: 0.1,
              ),
              border: Border.all(
                color: (_isActivated ? accentGreen : Colors.grey).withValues(
                  alpha: 0.3,
                ),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.wifi_tethering_rounded,
              color: _isActivated ? accentGreen : Colors.grey[300],
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isActivated ? "SYSTEM LIVE" : "SYSTEM IDLE",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: _isActivated ? accentGreen : Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isActivated
                ? "Students can join the session"
                : "Activate to allow student login",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Quick action shortcuts
  Widget _buildQuickActions(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "QUICK ACTIONS",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 11,
              color: darkNavy,
            ),
          ),
          const SizedBox(height: 12),
          _quickActionTile(
            Icons.casino_outlined,
            "Start Recitation",
            "Pick a random student",
            Colors.purple,
          ),
          const SizedBox(height: 8),
          _quickActionTile(
            Icons.quiz_outlined,
            "Launch Quiz",
            "Start a new assessment",
            accentGold,
          ),
          const SizedBox(height: 8),
          _quickActionTile(
            Icons.file_download_outlined,
            "Export Report",
            "Download attendance log",
            darkNavy,
          ),
        ],
      ),
    );
  }

  Widget _quickActionTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: darkNavy,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: color.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: _actionBtn(
            "ACTIVATE",
            Icons.bolt_rounded,
            _isActivated ? Colors.grey.shade300 : accentGreen,
            _isActivated ? null : () => setState(() => _isActivated = true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _actionBtn(
            "END SESSION",
            Icons.power_settings_new_rounded,
            !_isActivated ? Colors.grey.shade300 : accentRed,
            !_isActivated ? null : () => _confirmEndSession(),
          ),
        ),
      ],
    );
  }

  void _confirmEndSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: accentRed),
            SizedBox(width: 10),
            Text("End Session?", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          "This will close the session and save all attendance records. Students will no longer be able to log in.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isActivated = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "END SESSION",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    String label,
    IconData icon,
    Color color,
    VoidCallback? tap,
  ) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: tap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
