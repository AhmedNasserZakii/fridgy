import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';

enum FoodDetailStatus { initial, loading, success, failure }

class FoodDetailState extends Equatable {
  const FoodDetailState({
    this.status = FoodDetailStatus.initial,
    this.item,
    this.message,
    this.consumeLoading = false,
    this.consumeSucceeded = false,
  });

  final FoodDetailStatus status;
  final FoodItemEntity? item;
  final String? message;
  final bool consumeLoading;
  final bool consumeSucceeded;

  FoodDetailState copyWith({
    FoodDetailStatus? status,
    FoodItemEntity? item,
    String? message,
    bool clearMessage = false,
    bool? consumeLoading,
    bool? consumeSucceeded,
  }) {
    return FoodDetailState(
      status: status ?? this.status,
      item: item ?? this.item,
      message: clearMessage ? null : (message ?? this.message),
      consumeLoading: consumeLoading ?? this.consumeLoading,
      consumeSucceeded: consumeSucceeded ?? this.consumeSucceeded,
    );
  }

  @override
  List<Object?> get props => [
        status,
        item,
        message,
        consumeLoading,
        consumeSucceeded,
      ];
}
