import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_entity.dart';

enum OrderDetailStatus { loading, success, failure }

enum OrderDetailActionStatus { idle, working, intakeReady, failure }

class OrderDetailState extends Equatable {
  const OrderDetailState({
    this.status = OrderDetailStatus.loading,
    this.order,
    this.message,
    this.actionStatus = OrderDetailActionStatus.idle,
    this.intake,
  });

  final OrderDetailStatus status;
  final OrderEntity? order;
  final String? message;
  final OrderDetailActionStatus actionStatus;
  final FridgeIntakeEntity? intake;

  OrderDetailState copyWith({
    OrderDetailStatus? status,
    OrderEntity? order,
    String? message,
    OrderDetailActionStatus? actionStatus,
    FridgeIntakeEntity? intake,
    bool clearMessage = false,
    bool clearIntake = false,
  }) {
    return OrderDetailState(
      status: status ?? this.status,
      order: order ?? this.order,
      message: clearMessage ? null : (message ?? this.message),
      actionStatus: actionStatus ?? this.actionStatus,
      intake: clearIntake ? null : (intake ?? this.intake),
    );
  }

  @override
  List<Object?> get props => [status, order, message, actionStatus, intake];
}
