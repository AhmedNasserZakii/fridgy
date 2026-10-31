import 'package:equatable/equatable.dart';

/// Notification Settings screen (More tab) — mirrors
/// `notification-settings` GET/PUT response `data`.
class NotificationSettingsEntity extends Equatable {
  const NotificationSettingsEntity({
    required this.osPermissionGranted,
    required this.expiryRemindersEnabled,
    required this.remindDaysBefore,
    required this.reminderTime,
    required this.timezone,
    required this.shoppingListUpdates,
    required this.householdActivity,
    required this.weeklyImpactRecap,
  });

  /// Whether the OS has granted the app permission to send notifications.
  /// Read-only — only iOS/Android settings can change this.
  final bool osPermissionGranted;

  final bool expiryRemindersEnabled;

  /// Days before an item's expiry date to send a reminder (1–14).
  final int remindDaysBefore;

  /// 24h `HH:mm` local time, e.g. `09:00`.
  final String reminderTime;

  /// IANA timezone, e.g. `Africa/Cairo`.
  final String timezone;

  final bool shoppingListUpdates;
  final bool householdActivity;
  final bool weeklyImpactRecap;

  NotificationSettingsEntity copyWith({
    bool? osPermissionGranted,
    bool? expiryRemindersEnabled,
    int? remindDaysBefore,
    String? reminderTime,
    String? timezone,
    bool? shoppingListUpdates,
    bool? householdActivity,
    bool? weeklyImpactRecap,
  }) {
    return NotificationSettingsEntity(
      osPermissionGranted: osPermissionGranted ?? this.osPermissionGranted,
      expiryRemindersEnabled:
          expiryRemindersEnabled ?? this.expiryRemindersEnabled,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      reminderTime: reminderTime ?? this.reminderTime,
      timezone: timezone ?? this.timezone,
      shoppingListUpdates: shoppingListUpdates ?? this.shoppingListUpdates,
      householdActivity: householdActivity ?? this.householdActivity,
      weeklyImpactRecap: weeklyImpactRecap ?? this.weeklyImpactRecap,
    );
  }

  @override
  List<Object?> get props => [
    osPermissionGranted,
    expiryRemindersEnabled,
    remindDaysBefore,
    reminderTime,
    timezone,
    shoppingListUpdates,
    householdActivity,
    weeklyImpactRecap,
  ];
}
