import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<KidmeNotification> _notifications = [
    KidmeNotification(
      id: '1',
      title: 'New Job Match!',
      body: 'A new Flutter Developer role matches your skills at Fale Tech.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: NotificationType.jobMatch,
    ),
    KidmeNotification(
      id: '2',
      title: 'Application Update',
      body: 'Your application for "Monitoring Assistant" has been shortlisted.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.applicationUpdate,
    ),
    KidmeNotification(
      id: '3',
      title: 'Message Received',
      body: 'UNICEF Chad sent you a message regarding your application.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.message,
    ),
    KidmeNotification(
      id: '4',
      title: 'Event Booking Confirmed',
      body: 'Your slot for "Tech Careers in Chad" webinar is confirmed.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.eventBooking,
    ),
  ];

  bool _showOnlyApplicationUpdates = false;

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _showOnlyApplicationUpdates
        ? _notifications
              .where((n) => n.type == NotificationType.applicationUpdate)
              .toList()
        : _notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') _clearAll();
                if (value == 'read') _markAllAsRead();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'read',
                  child: Text('Mark all as read'),
                ),
                const PopupMenuItem(value: 'clear', child: Text('Clear all')),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter by Application Updates',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _showOnlyApplicationUpdates,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyApplicationUpdates = value;
                    });
                  },
                  activeColor: AppColors.emerald,
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: AppColors.softGrey,
                        ),
                        const SizedBox(height: 16),
                        const Text('No notifications yet'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _NotificationTile(notification: notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final KidmeNotification notification;

  const _NotificationTile({required this.notification});

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.jobMatch:
        return Icons.auto_awesome_rounded;
      case NotificationType.message:
        return Icons.chat_bubble_outline_rounded;
      case NotificationType.eventBooking:
        return Icons.event_available_rounded;
      case NotificationType.applicationUpdate:
        return Icons.assignment_turned_in_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.isRead
          ? Colors.transparent
          : AppColors.blueMist.withOpacity(0.3),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.blueMist,
          child: Icon(_getIcon(), color: AppColors.professionalBlue, size: 20),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: const TextStyle(fontSize: 11, color: AppColors.softGrey),
            ),
          ],
        ),
        onTap: () {
          // Logic to navigate or mark as read
        },
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
