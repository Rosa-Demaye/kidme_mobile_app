import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class EventsForYouScreen extends StatelessWidget {
  const EventsForYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events For You'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Recommended Events',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 16),
          _EventCard(
            title: 'Tech Careers in Chad',
            date: 'May 30, 2026',
            location: 'Online',
            type: 'Webinar',
            imageColor: Colors.blue.shade100,
          ),
          const SizedBox(height: 16),
          _EventCard(
            title: 'NGO Recruitment Fair',
            date: 'June 05, 2026',
            location: "N'Djamena",
            type: 'Fair',
            imageColor: Colors.green.shade100,
          ),
          const SizedBox(height: 16),
          _EventCard(
            title: 'CV Building Workshop',
            date: 'June 12, 2026',
            location: 'Moundou',
            type: 'Workshop',
            imageColor: Colors.orange.shade100,
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String type;
  final Color imageColor;

  const _EventCard({
    required this.title,
    required this.date,
    required this.location,
    required this.type,
    required this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: imageColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Icon(
              Icons.event_note_rounded,
              size: 48,
              color: imageColor.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueMist,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.professionalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.bookmark_border_rounded,
                      color: AppColors.softGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      size: 16,
                      color: AppColors.softGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(color: AppColors.softGrey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.softGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      location,
                      style: const TextStyle(color: AppColors.softGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
