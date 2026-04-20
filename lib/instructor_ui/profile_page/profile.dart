import 'package:flutter/material.dart';
import '../login_page/login.dart';

class InstructorProfilePage extends StatefulWidget {
  final String currentCode;
  final String currentName;

  const InstructorProfilePage({
    super.key,
    required this.currentCode,
    required this.currentName,
  });

  @override
  State<InstructorProfilePage> createState() => _InstructorProfilePageState();
}

class _InstructorProfilePageState extends State<InstructorProfilePage> {
  static const Color stiNavy = Color(0xFF0D125A);
  static const Color stiGold = Color(0xFFFFD100);
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Colors.white;

  void _showChangePasswordDialog() {
    final TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Change System Password",
          style: TextStyle(color: stiNavy, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter a new password for your instructor account.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "New Password",
                filled: true,
                fillColor: bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: stiNavy),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password updated successfully!")),
              );
            },
            child: const Text("UPDATE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _downloadLogs() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: stiGold),
            ),
            SizedBox(width: 20),
            Text("Preparing activity_logs.pdf..."),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Download Complete: activity_logs.pdf saved."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final hPad = isDesktop ? 60.0 : 16.0;

    return Material(
      color: bgColor,
      child: Column(
        children: [
          _buildTopNavigationBar(isDesktop),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: isDesktop ? 40 : 20,
              ),
              child: Column(
                children: [
                  // Hero section
                  _buildHeroSection(isDesktop),
                  SizedBox(height: isDesktop ? 40 : 20),

                  // Info cards — side by side on desktop, stacked on phone
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildInfoCard(
                                title: "ACCOUNT IDENTITY",
                                icon: Icons.verified_user_rounded,
                                children: [
                                  _modernDataTile(
                                    Icons.badge_rounded,
                                    "STAFF ID",
                                    "STI-2026-0412",
                                  ),
                                  const SizedBox(height: 25),
                                  _modernDataTile(
                                    Icons.email_rounded,
                                    "INSTITUTIONAL EMAIL",
                                    "claire.reyes@sti.edu.ph",
                                  ),
                                ],
                                isDesktop: isDesktop,
                              ),
                              const SizedBox(height: 30),
                              _buildAppPreferencesCard(context, isDesktop),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 3,
                          child: _buildInfoCard(
                            title: "ACTIVE SESSION DATA",
                            icon: Icons.hub_rounded,
                            children: [
                              _buildWarningBanner(),
                              const SizedBox(height: 35),
                              _modernDataTile(
                                Icons.terminal_rounded,
                                "CURRENT SUBJECT CODE",
                                widget.currentCode.toUpperCase(),
                              ),
                              const SizedBox(height: 25),
                              _modernDataTile(
                                Icons.auto_stories_rounded,
                                "REGISTERED SUBJECT NAME",
                                widget.currentName,
                              ),
                            ],
                            isDesktop: isDesktop,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildInfoCard(
                          title: "ACTIVE SESSION DATA",
                          icon: Icons.hub_rounded,
                          children: [
                            _buildWarningBanner(),
                            const SizedBox(height: 20),
                            _modernDataTile(
                              Icons.terminal_rounded,
                              "SUBJECT CODE",
                              widget.currentCode.toUpperCase(),
                            ),
                            const SizedBox(height: 16),
                            _modernDataTile(
                              Icons.auto_stories_rounded,
                              "SUBJECT NAME",
                              widget.currentName,
                            ),
                          ],
                          isDesktop: isDesktop,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          title: "ACCOUNT IDENTITY",
                          icon: Icons.verified_user_rounded,
                          children: [
                            _modernDataTile(
                              Icons.badge_rounded,
                              "STAFF ID",
                              "STI-2026-0412",
                            ),
                            const SizedBox(height: 16),
                            _modernDataTile(
                              Icons.email_rounded,
                              "EMAIL",
                              "claire.reyes@sti.edu.ph",
                            ),
                          ],
                          isDesktop: isDesktop,
                        ),
                        const SizedBox(height: 16),
                        _buildAppPreferencesCard(context, isDesktop),
                      ],
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavigationBar(bool isDesktop) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 16),
      decoration: const BoxDecoration(
        color: surfaceWhite,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.account_circle_outlined, color: stiNavy, size: 24),
          SizedBox(width: 15),
          Text(
            "SYSTEM PROFILE",
            style: TextStyle(
              color: stiNavy,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              fontFamily: 'serif',
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  // Hero section — large on desktop, compact on phone
  Widget _buildHeroSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDesktop ? 35 : 20),
        gradient: const LinearGradient(
          colors: [stiNavy, Color(0xFF000033)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: stiNavy.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: isDesktop ? _buildDesktopHero() : _buildPhoneHero(),
    );
  }

  // Desktop hero — full size, horizontal layout
  Widget _buildDesktopHero() {
    return Stack(
      children: [
        Positioned(
          right: -50,
          top: -50,
          child: CircleAvatar(
            radius: 150,
            backgroundColor: Colors.white.withValues(alpha: 0.03),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(60),
          child: Row(
            children: [
              _buildProfileAvatar(75),
              const SizedBox(width: 50),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Claire Reyes",
                      style: TextStyle(
                        color: surfaceWhite,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'serif',
                      ),
                    ),
                    const Text(
                      "Senior Professor • Information Technology Department",
                      style: TextStyle(
                        color: stiGold,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        _heroChip(Icons.calendar_today_rounded, "Joined 2021"),
                        const SizedBox(width: 15),
                        _heroChip(Icons.stars_rounded, "Faculty Elite"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Phone hero — compact, centered, vertical layout
  Widget _buildPhoneHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Row(
        children: [
          _buildProfileAvatar(36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Claire Reyes",
                  style: TextStyle(
                    color: surfaceWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Senior Professor • IT Department",
                  style: TextStyle(
                    color: stiGold,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _heroChipSmall(Icons.calendar_today_rounded, "Joined 2021"),
                    _heroChipSmall(Icons.stars_rounded, "Faculty Elite"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(double radius) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(color: stiGold, shape: BoxShape.circle),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Icon(Icons.person_rounded, size: radius * 1.1, color: stiNavy),
      ),
    );
  }

  Widget _heroChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: stiGold),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Smaller version of the chip for phone hero
  Widget _heroChipSmall(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: stiGold),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isDesktop,
  }) {
    final pad = isDesktop ? 40.0 : 20.0;
    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(isDesktop ? 30 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: stiGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: stiNavy, size: 20),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: stiNavy,
                  fontSize: 13,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isDesktop ? 30 : 16),
            child: const Divider(color: Color(0xFFF1F5F9), thickness: 2),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _modernDataTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[400]),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: stiNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.security_update_good_rounded,
            color: Color(0xFF1D4ED8),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Analytics and records are scoped to the course ID below.",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppPreferencesCard(BuildContext context, bool isDesktop) {
    return _buildInfoCard(
      title: "PREFERENCES",
      icon: Icons.tune_rounded,
      children: [
        _clickableRow(
          "Change System Password",
          Icons.lock_open_rounded,
          _showChangePasswordDialog,
        ),
        _clickableRow(
          "Download Activity Logs",
          Icons.cloud_download_outlined,
          _downloadLogs,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const InstructorLoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text(
              "CLOSE SESSION",
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
      isDesktop: isDesktop,
    );
  }

  Widget _clickableRow(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: stiNavy),
              const SizedBox(width: 15),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: stiNavy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
