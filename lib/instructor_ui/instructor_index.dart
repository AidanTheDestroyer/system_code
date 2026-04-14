import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'home_page/dashboard.dart';
import 'profile_page/profile.dart';
import 'attendance_page/attendance_shell.dart';
import 'recitation_page/recitation_facilitator.dart';
import 'grades_page/grade_history.dart';
import 'assessment_page/assessment_list.dart';

class InstructorIndex extends StatefulWidget {
  final String selectedSubjectCode;
  final String selectedSubjectName;

  const InstructorIndex({
    super.key,
    required this.selectedSubjectCode,
    required this.selectedSubjectName,
  });

  @override
  State<InstructorIndex> createState() => _InstructorIndexState();
}

class _InstructorIndexState extends State<InstructorIndex> {
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;

          if (isDesktop) {
            // Desktop layout — sidebar on left, content on right
            return Row(
              children: [
                InstructorSidebar(
                  selectedIndex: _selectedIndex,
                  onPageChanged: _onPageChanged,
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _buildPages(),
                  ),
                ),
              ],
            );
          } else {
            // Phone layout — bottom navigation bar
            return SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xFFF8FAFC),
                body: IndexedStack(
                  index: _selectedIndex,
                  children: _buildPages(),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onPageChanged,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: const Color(0xFF000080),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white54,
                  selectedLabelStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(fontSize: 10),
                  elevation: 0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard_outlined),
                      activeIcon: Icon(Icons.dashboard),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month_outlined),
                      activeIcon: Icon(Icons.calendar_month),
                      label: 'Attendance',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.record_voice_over_outlined),
                      activeIcon: Icon(Icons.record_voice_over),
                      label: 'Recitation',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.grade_outlined),
                      activeIcon: Icon(Icons.grade),
                      label: 'Grades',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.library_books_outlined),
                      activeIcon: Icon(Icons.library_books),
                      label: 'Assessment',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle_outlined),
                      activeIcon: Icon(Icons.account_circle),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      InstructorDashboard(
        subjectCode: widget.selectedSubjectCode,
        subjectName: widget.selectedSubjectName,
        courseData: const {
          'students': [
            'Alex Johnson',
            'Maria Garcia',
            'Tony Hugh',
            'Jet Hinks',
            'Samuel Pru',
          ],
        },
      ),
      InstructorAttendanceHistory(
        subjectCode: widget.selectedSubjectCode,
        subjectName: widget.selectedSubjectName,
      ),
      RecitationFacilitatorPage(
        subjectCode: widget.selectedSubjectCode,
        subjectName: widget.selectedSubjectName,
      ),
      GradesManagementPage(
        subjectCode: widget.selectedSubjectCode,
        subjectName: widget.selectedSubjectName,
      ),
      const AssessmentHubPage(),
      InstructorProfilePage(
        currentCode: widget.selectedSubjectCode,
        currentName: widget.selectedSubjectName,
      ),
    ];
  }
}
