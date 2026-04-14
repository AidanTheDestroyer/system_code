import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../notification_page/notification.dart';

class InstructorAttendanceHistory extends StatefulWidget {
  final String subjectCode;
  final String subjectName;

  const InstructorAttendanceHistory({
    super.key,
    required this.subjectCode,
    required this.subjectName,
  });

  @override
  State<InstructorAttendanceHistory> createState() =>
      _InstructorAttendanceHistoryState();
}

class _InstructorAttendanceHistoryState
    extends State<InstructorAttendanceHistory> {
  static const Color stiNavy = Color(0xFF000080);
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color tableHeaderColor = Color(0xFFF1F5F9);
  static const Color statusGreen = Color(0xFF43A047);
  static const Color statusRed = Color(0xFFE53935);
  static const Color statusOrange = Color(0xFFFB8C00);

  final TextEditingController _searchController = TextEditingController();
  String _currentSearch = "";
  String _currentDateFilter = "2026-03-09";

  // All enrolled students are listed here regardless of status
  final List<Map<String, String>> _allLogs = [
    {
      "date": "2026-03-09",
      "name": "Alex Johnson",
      "id": "020004567992",
      "status": "Present",
      "in": "1:30 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-09",
      "name": "Maria Garcia",
      "id": "02000874933",
      "status": "Present",
      "in": "1:30 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-09",
      "name": "Tony Hugh",
      "id": "02000983643",
      "status": "Absent",
      "in": " - ",
      "out": " - ",
    },
    {
      "date": "2026-03-09",
      "name": "Jet Hinks",
      "id": "02000327643",
      "status": "Late",
      "in": "3:30 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-09",
      "name": "Amigo, Raphael",
      "id": "02000111111",
      "status": "Absent",
      "in": " - ",
      "out": " - ",
    },
    {
      "date": "2026-03-09",
      "name": "Brusco, Hannah",
      "id": "02000222222",
      "status": "Absent",
      "in": " - ",
      "out": " - ",
    },
    {
      "date": "2026-03-10",
      "name": "Alex Johnson",
      "id": "020004567992",
      "status": "Present",
      "in": "1:30 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-10",
      "name": "Maria Garcia",
      "id": "02000874933",
      "status": "Absent",
      "in": " - ",
      "out": " - ",
    },
    {
      "date": "2026-03-10",
      "name": "Tony Hugh",
      "id": "02000983643",
      "status": "Absent",
      "in": " - ",
      "out": " - ",
    },
    {
      "date": "2026-03-10",
      "name": "Jet Hinks",
      "id": "02000327643",
      "status": "Present",
      "in": "1:30 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-10",
      "name": "Amigo, Raphael",
      "id": "02000111111",
      "status": "Late",
      "in": "2:00 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-10",
      "name": "Brusco, Hannah",
      "id": "02000222222",
      "status": "Present",
      "in": "1:30 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-11",
      "name": "Alex Johnson",
      "id": "020004567992",
      "status": "Late",
      "in": "3:00 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-11",
      "name": "Maria Garcia",
      "id": "02000874933",
      "status": "Present",
      "in": "1:30 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-11",
      "name": "Tony Hugh",
      "id": "02000983643",
      "status": "Absent",
      "in": " - ",
      "out": " - ",
    },
    {
      "date": "2026-03-11",
      "name": "Jet Hinks",
      "id": "02000327643",
      "status": "Present",
      "in": "1:30 pm",
      "out": "7:00 pm",
    },
    {
      "date": "2026-03-11",
      "name": "Amigo, Raphael",
      "id": "02000111111",
      "status": "Absent",
      "in": " - ",
      "out": " - ",
    },
    {
      "date": "2026-03-11",
      "name": "Brusco, Hannah",
      "id": "02000222222",
      "status": "Present",
      "in": "1:30 pm",
      "out": "7:00 pm",
    },
  ];

  List<Map<String, String>> _filteredLogs = [];

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
      _filteredLogs = _allLogs.where((log) {
        bool matchesSearch =
            log["name"]!.toLowerCase().contains(_currentSearch.toLowerCase()) ||
            log["id"]!.contains(_currentSearch);
        bool matchesDate = log["date"] == _currentDateFilter;
        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  // Cycles through Present → Late → Absent → Present
  void _cycleStatus(int index) {
    final current = _filteredLogs[index]["status"]!;
    String next;
    switch (current) {
      case "Present":
        next = "Late";
        break;
      case "Late":
        next = "Absent";
        break;
      default:
        next = "Present";
    }

    // Find and update in the master list too
    final logId = _filteredLogs[index]["id"];
    final logDate = _filteredLogs[index]["date"];
    final masterIndex = _allLogs.indexWhere(
      (l) => l["id"] == logId && l["date"] == logDate,
    );

    setState(() {
      _filteredLogs[index] = Map.from(_filteredLogs[index])
        ..["status"] = next
        ..["in"] = next == "Absent" ? " - " : _filteredLogs[index]["in"]!
        ..["out"] = next == "Absent" ? " - " : _filteredLogs[index]["out"]!;

      if (masterIndex != -1) {
        _allLogs[masterIndex] = Map.from(_allLogs[masterIndex])
          ..["status"] = next
          ..["in"] = next == "Absent" ? " - " : _allLogs[masterIndex]["in"]!
          ..["out"] = next == "Absent" ? " - " : _allLogs[masterIndex]["out"]!;
      }
    });
  }

  void _handleExport() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 2000)),
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
                      "EXPORTING LOGS",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: stiNavy,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Compiling ${widget.subjectCode} data...",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                      "EXPORT SUCCESSFUL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: stiNavy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Attendance report saved to downloads.",
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
                          "OK",
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

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    return Column(
      children: [
        _buildStandardHeader(
          "${widget.subjectCode} Attendance Logs",
          isDesktop,
        ),
        _buildFilterHeader(isDesktop),
        _buildActionRow(isDesktop),
        Expanded(child: _buildTableCard(isDesktop)),
      ],
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
            "Class: ${widget.subjectName}",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
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
                    onChanged: (v) {
                      _currentSearch = v;
                      _applyFilters();
                    },
                    decoration: const InputDecoration(
                      hintText: "Search student name...",
                      prefixIcon: Icon(Icons.search, size: 20, color: stiNavy),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: isDesktop ? 1 : 2,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentDateFilter,
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: stiNavy,
                      ),
                      isExpanded: true,
                      items: ["2026-03-09", "2026-03-10", "2026-03-11"].map((
                        date,
                      ) {
                        return DropdownMenuItem(
                          value: date,
                          child: Text(
                            DateFormat('MM/dd/yy').format(DateTime.parse(date)),
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _currentDateFilter = v!;
                          _applyFilters();
                        });
                      },
                    ),
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
          // Status legend
          Row(
            children: [
              _legendDot(statusGreen, "Present"),
              const SizedBox(width: 12),
              _legendDot(statusOrange, "Late"),
              const SizedBox(width: 12),
              _legendDot(statusRed, "Absent"),
            ],
          ),
          _buildActionButton("EXPORT REPORT", Icons.file_download_outlined),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: _handleExport,
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: stiNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildTableCard(bool isDesktop) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        isDesktop ? 32 : 16,
        10,
        isDesktop ? 32 : 16,
        isDesktop ? 32 : 16,
      ),
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
          // Table header
          Container(
            height: 50,
            decoration: const BoxDecoration(
              color: tableHeaderColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                if (isDesktop) _cell("DATE", flex: 2, isHeader: true),
                _cell("NAME", flex: 3, isHeader: true),
                _cell("STATUS", flex: 2, isHeader: true),
                if (isDesktop) _cell("IN/OUT", flex: 2, isHeader: true),
              ],
            ),
          ),
          // Table rows
          Expanded(
            child: ListView.separated(
              itemCount: _filteredLogs.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                return SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      if (isDesktop)
                        _cell(
                          DateFormat(
                            'MM/dd/yy',
                          ).format(DateTime.parse(_filteredLogs[i]["date"]!)),
                          flex: 2,
                        ),
                      _cell(_filteredLogs[i]["name"]!, flex: 3, isBold: true),
                      _clickableStatusBadge(i, flex: 2),
                      if (isDesktop)
                        _cell(
                          "${_filteredLogs[i]["in"]} / ${_filteredLogs[i]["out"]}",
                          flex: 2,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Summary footer
          Container(
            height: 44,
            decoration: const BoxDecoration(
              color: tableHeaderColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryChip(
                  "Present",
                  _filteredLogs.where((l) => l["status"] == "Present").length,
                  statusGreen,
                ),
                _summaryChip(
                  "Late",
                  _filteredLogs.where((l) => l["status"] == "Late").length,
                  statusOrange,
                ),
                _summaryChip(
                  "Absent",
                  _filteredLogs.where((l) => l["status"] == "Absent").length,
                  statusRed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(
    String text, {
    required int flex,
    bool isHeader = false,
    bool isBold = false,
  }) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isHeader ? 10 : 12,
              fontWeight: (isHeader || isBold)
                  ? FontWeight.w900
                  : FontWeight.normal,
              color: isHeader ? stiNavy : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // Clickable status badge — tapping cycles through Present → Late → Absent
  Widget _clickableStatusBadge(int index, {required int flex}) {
    final status = _filteredLogs[index]["status"]!;
    Color color = status == "Present"
        ? statusGreen
        : (status == "Absent" ? statusRed : statusOrange);

    return Expanded(
      flex: flex,
      child: Center(
        child: Tooltip(
          message: "Tap to change status",
          child: GestureDetector(
            onTap: () => _cycleStatus(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.swap_vert_rounded, size: 10, color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryChip(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          "$count $label",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
