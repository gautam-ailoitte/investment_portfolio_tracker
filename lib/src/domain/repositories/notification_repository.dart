abstract class NotificationRepository {
  /// Send push notification
  Future<void> sendPushNotification({
    required String title,
    required String message,
    Map<String, dynamic>? data,
  });

  /// Schedule notification
  Future<void> scheduleNotification({
    required String id,
    required String title,
    required String message,
    required DateTime scheduledTime,
    Map<String, dynamic>? data,
  });

  /// Cancel scheduled notification
  Future<void> cancelNotification(String id);

  /// Get notification settings
  Future<Map<String, bool>> getNotificationSettings();

  /// Update notification settings
  Future<void> updateNotificationSettings(Map<String, bool> settings);

  /// Register for push notifications
  Future<String?> registerForPushNotifications();

  /// Unregister from push notifications
  Future<void> unregisterFromPushNotifications();

  /// Get notification history
  Future<List<Map<String, dynamic>>> getNotificationHistory();

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId);

  /// Clear all notifications
  Future<void> clearAllNotifications();

  /// Stream of notification updates
  Stream<Map<String, dynamic>> get notificationStream;
}
