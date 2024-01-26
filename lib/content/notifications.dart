import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'daily_notifications',
          channelName: 'Codzienne Powiadomienia',
          channelDescription:
              'Powiadomienia wysyłane codziennie o ustalonych godzinach',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color.fromARGB(0, 255, 255, 255),
        ),
      ],
    );

    await scheduleDailyNotifications();
  }

  Future<void> scheduleDailyNotifications() async {
    List<Map<String, dynamic>> notificationSchedules = [
      {
        'hour': 10,
        'minute': 0,
        'title': 'Kawa już wypita?',
        'body': 'Napisz jak się teraz czujesz?'
      },
      {
        'hour': 14,
        'minute': 0,
        'title': 'Jak ci mija popołudnie?',
        'body': 'Napisz jak się teraz czujesz?'
      },
      {
        'hour': 18,
        'minute': 0,
        'title': 'Już wieczór a może...',
        'body': 'Napiszesz jak się teraz czujesz?'
      },
    ];

    for (var schedule in notificationSchedules) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: UniqueKey().hashCode,
          channelKey: 'daily_notifications',
          title: schedule['title'],
          body: schedule['body'],
        ),
        schedule: NotificationCalendar(
          hour: schedule['hour'],
          minute: schedule['minute'],
          second: 0,
          millisecond: 0,
          repeats: true,
        ),
      );
    }
  }
}
