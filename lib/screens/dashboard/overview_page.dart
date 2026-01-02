import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/widgets/stat_card.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'Overview',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Statistics',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              childAspectRatio: 1.5,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                StatCard(
                  title: 'Total Users',
                  value: '1,234',
                  icon: Iconsax.people,
                  color: Colors.blue,
                ),
                StatCard(
                  title: 'Total Orders',
                  value: '856',
                  icon: Iconsax.box,
                  color: Colors.orange,
                ),
                StatCard(
                  title: 'Revenue',
                  value: '\$45,231',
                  icon: Iconsax.money,
                  color: Colors.green,
                ),
                StatCard(
                  title: 'Active Tailors',
                  value: '42',
                  icon: Iconsax.scissor,
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
