import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Calendar'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CalendarHeader(),
            const SizedBox(height: 24),
            const Text(
              'Upcoming Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 16),
            _ScheduleItem(
              time: '10:00 AM',
              title: 'Interview with UNICEF',
              date: 'Monday, May 25',
              color: Colors.blue.shade400,
            ),
            const SizedBox(height: 12),
            _ScheduleItem(
              time: '02:30 PM',
              title: 'Tech Careers Webinar',
              date: 'Wednesday, May 27',
              color: Colors.purple.shade400,
            ),
            const SizedBox(height: 12),
            _ScheduleItem(
              time: '09:00 AM',
              title: 'Project Deadline',
              date: 'Friday, May 29',
              color: Colors.red.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader();

  @override
  Widget build(BuildContext context) {
    // Simplified calendar grid for UI representation
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'May 2026',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Mock day labels
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'M',
                  style: TextStyle(
                    color: AppColors.softGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'T',
                  style: TextStyle(
                    color: AppColors.softGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'W',
                  style: TextStyle(
                    color: AppColors.softGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'T',
                  style: TextStyle(
                    color: AppColors.softGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'F',
                  style: TextStyle(
                    color: AppColors.softGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'S',
                  style: TextStyle(
                    color: AppColors.softGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'S',
                  style: TextStyle(
                    color: AppColors.softGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Mock grid of days
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: 31,
              itemBuilder: (context, index) {
                final day = index + 1;
                final isSelected = day == 25;
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryNavy
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryNavy,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final String date;
  final Color color;

  const _ScheduleItem({
    required this.time,
    required this.title,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date • $time',
                  style: const TextStyle(
                    color: AppColors.softGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: AppColors.softGrey),
        ],
      ),
    );
  }
}
