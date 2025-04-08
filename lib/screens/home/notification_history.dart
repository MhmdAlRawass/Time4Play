import 'package:flutter/material.dart';

class NotificationHistory extends StatefulWidget {
  const NotificationHistory({super.key});

  @override
  State<NotificationHistory> createState() => _NotificationHistoryState();
}

class _NotificationHistoryState extends State<NotificationHistory>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Welcome to our App!',
      'message': 'Thanks for joining. Enjoy exploring the features.',
      'time': '2 mins ago',
      'icon': Icons.new_releases,
    },
    {
      'title': 'Booking Confirmed',
      'message': 'Your booking for the Soccer field is confirmed for tomorrow.',
      'time': '1 hour ago',
      'icon': Icons.check_circle,
    },
    {
      'title': 'Special Offer',
      'message': 'Get 30% discount on your next booking between 8PM - 11PM.',
      'time': '3 hours ago',
      'icon': Icons.local_offer,
    },
    {
      'title': 'Reminder',
      'message': 'Don\'t forget your upcoming booking at the Tennis Court.',
      'time': 'Yesterday',
      'icon': Icons.alarm,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Delay inserting notifications to create a blowing up effect
    Future.delayed(const Duration(milliseconds: 300), () {
      for (int i = 0; i < notifications.length; i++) {
        Future.delayed(Duration(milliseconds: i * 200), () {
          _listKey.currentState?.insertItem(i);
        });
      }
    });
  }

  void _removeNotification(int index) {
    final removedItem = notifications[index];

    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          _buildNotificationItem(removedItem, animation, index),
      duration: const Duration(milliseconds: 300),
    );

    setState(() {
      notifications.removeAt(index);
    });
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification,
      Animation<double> animation, int index) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent.withOpacity(0.3),
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12), // Ensure rounded corners
          child: Dismissible(
            key: Key(notification['title']),
            onDismissed: (direction) {
              _removeNotification(index);
            },
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              color: Colors.red
                  .withOpacity(0.2), // Red background only for content
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red
                  .withOpacity(0.2), // Red background for the other side
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
                child: Icon(
                  notification['icon'],
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                notification['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['message'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SwipeHintWidget(),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.all(16),
              initialItemCount: 0, // Start empty, notifications will animate in
              itemBuilder: (context, index, animation) {
                return _buildNotificationItem(
                    notifications[index], animation, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeHintWidget extends StatefulWidget {
  const SwipeHintWidget({super.key});

  @override
  State<SwipeHintWidget> createState() => _SwipeHintWidgetState();
}

class _SwipeHintWidgetState extends State<SwipeHintWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.2, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.error.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Swipe left or right to delete notifications"),
          const SizedBox(width: 8),
          SlideTransition(
            position: _slideAnimation,
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
