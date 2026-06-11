import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notification = FlutterLocalNotificationsPlugin();

  void showNotification(String title, String body) async{

    var android = AndroidNotificationDetails(
      'Products', 'stock_notifications',
      priority: Priority.high, importance: Importance.max
    );

    var platform = NotificationDetails(android: android);

    await notification.show(
        id: 0,
        title: '',
        body: '',
        //platform: platform,
        payload: 'test'
    );
  }
}