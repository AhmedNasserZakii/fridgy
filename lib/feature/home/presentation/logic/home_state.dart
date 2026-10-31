import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/home/domain/entities/home_dashboard_entity.dart';

enum HomeStatus { loading, loaded, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.loading,
    this.dashboard,
    this.user,
    this.message,
  });

  final HomeStatus status;
  final HomeDashboardEntity? dashboard;
  final UserEntity? user;
  final String? message;

  HomeState copyWith({
    HomeStatus? status,
    HomeDashboardEntity? dashboard,
    UserEntity? user,
    String? message,
    bool clearMessage = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      user: user ?? this.user,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, dashboard, user, message];
}
