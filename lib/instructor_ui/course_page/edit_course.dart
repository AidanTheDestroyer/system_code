import 'package:flutter/material.dart';

class EditCoursePage extends StatefulWidget {
  final Map<String, dynamic>? courseData;
  const EditCoursePage({super.key, this.courseData});

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  static const Color darkBlue = Color(0xFF000080);
  static const Color bgColor = Color(0xFFF4F7FA);
  static const Color borderSideColor = Color(0xFFEEEEEE);
  static const Color destructiveRed = Color(0xFFD32F2F);

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _locController;
  late TextEditingController _descController;

  TimeOfDay _startTime = const TimeOfDay(hour: 7, minute: 30);
  TimeOfDay _endTime = const TimeOfDay(hour: 9, minute: 30);

  final List<String> _students = [
    "Amigo, Raphael",
    "Brusco, Hannah",
    "Fabrino, Valerie",
    "Garcia, Maria",
    "Johnson, Alex",
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.courseData?['title'] ?? "",
    );
    _codeController = TextEditingController(
      text: widget.courseData?['code'] ?? "",
    );
    _locController = TextEditingController(
      text: widget.courseData?['room'] ?? "",
    );
    _descController = TextEditingController(
      text: widget.courseData?['desc'] ?? "",
    );
    _parseInitialTime();
  }

  void _parseInitialTime() {
    // Logic for parsing time if necessary
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _locController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: destructiveRed),
            SizedBox(width: 10),
            Text(
              "Delete Subject?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to permanently delete '${_nameController.text}'? "
          "All attendance records, grades, and student lists for this subject will be removed.",
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
              Navigator.pop(context, "DELETE");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: destructiveRed,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "DELETE SUBJECT",
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

  void _saveChanges() {
    if (_nameController.text.isEmpty || _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in the Subject Name and Code"),
        ),
      );
      return;
    }

    final updated = {
      "title": _nameController.text.toUpperCase(),
      "code": _codeController.text.toUpperCase(),
      "room": _locController.text,
      "desc": _descController.text,
      "sched": "${_startTime.format(context)} - ${_endTime.format(context)}",
      "color": widget.courseData?['color'] ?? darkBlue,
      "category": widget.courseData?['category'] ?? "Core",
      "studentCount": _students.length.toString(),
    };

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'EDIT SUBJECT DETAILS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 600;
                final leftCard = _buildMainCard(
                  child: Column(
                    children: [
                      _buildModernField(
                        "Subject Name",
                        _nameController,
                        Icons.book_outlined,
                      ),
                      const SizedBox(height: 18),
                      _buildModernField(
                        "Subject Code",
                        _codeController,
                        Icons.qr_code_2_outlined,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimeBox("Starts", _startTime, true),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTimeBox("Ends", _endTime, false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _buildModernField(
                        "Location / Room",
                        _locController,
                        Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 18),
                      _buildModernField(
                        "Short Description",
                        _descController,
                        Icons.description_outlined,
                        isMultiline: true,
                      ),
                    ],
                  ),
                );

                final rightCard = _buildMainCard(
                  child: Column(
                    children: [
                      const Text(
                        "STUDENT ENROLLMENT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                          letterSpacing: 1.1,
                          fontSize: 12,
                        ),
                      ),
                      const Divider(height: 30),
                      SizedBox(
                        height: 350,
                        child: _students.isEmpty
                            ? const Center(
                                child: Text(
                                  "No students enrolled",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _students.length,
                                itemBuilder: (context, index) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    backgroundColor: Color(0xFFF1F5F9),
                                    radius: 15,
                                    child: Icon(
                                      Icons.person,
                                      color: darkBlue,
                                      size: 16,
                                    ),
                                  ),
                                  title: Text(
                                    _students[index],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: destructiveRed,
                                      size: 18,
                                    ),
                                    onPressed: () => setState(
                                      () => _students.removeAt(index),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                );

                // Desktop: side by side. Phone: stacked vertically.
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: leftCard),
                      const SizedBox(width: 24),
                      Expanded(flex: 4, child: rightCard),
                    ],
                  );
                } else {
                  return Column(
                    children: [leftCard, const SizedBox(height: 20), rightCard],
                  );
                }
              },
            ),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 600;
                if (isDesktop) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBtn(
                        "DELETE SUBJECT",
                        destructiveRed,
                        _confirmDelete,
                        true,
                      ),
                      Row(
                        children: [
                          _buildBtn(
                            "DISCARD CHANGES",
                            Colors.black54,
                            () => Navigator.pop(context),
                            true,
                          ),
                          const SizedBox(width: 16),
                          _buildBtn(
                            "SAVE SUBJECT",
                            darkBlue,
                            _saveChanges,
                            false,
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBtn("SAVE SUBJECT", darkBlue, _saveChanges, false),
                      const SizedBox(height: 12),
                      _buildBtn(
                        "DISCARD CHANGES",
                        Colors.black54,
                        () => Navigator.pop(context),
                        true,
                      ),
                      const SizedBox(height: 12),
                      _buildBtn(
                        "DELETE SUBJECT",
                        destructiveRed,
                        _confirmDelete,
                        true,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            // FIXED: Used withValues(alpha: ...)
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTimeBox(String label, TimeOfDay time, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null)
              setState(() => isStart ? _startTime = picked : _endTime = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: borderSideColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.access_time, size: 18, color: darkBlue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: isMultiline ? 3 : 1,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            // FIXED: Used withValues(alpha: ...)
            prefixIcon: Icon(
              icon,
              size: 20,
              color: darkBlue.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: borderSideColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: darkBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBtn(String label, Color color, VoidCallback tap, bool outline) {
    return SizedBox(
      height: 52,
      width: MediaQuery.of(context).size.width > 600 ? 180 : double.infinity,
      child: outline
          ? OutlinedButton(
              onPressed: tap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: tap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
    );
  }
}
