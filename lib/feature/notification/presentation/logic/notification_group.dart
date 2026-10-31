import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';

/// A set of notifications that share the same local calendar date.
/// The presentation layer turns [date] into a "Today" / "Yesterday" / date
/// header (D10). Grouping itself is done in the cubit, not the widgets.
class NotificationGroup extends Equatable {
  const NotificationGroup({required this.date, required this.items});

  final DateTime date;
  final List<NotificationEntity> items;

  @override
  List<Object?> get props => [date, items];
}
