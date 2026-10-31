import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

enum FoodFormLoadStatus { idle, loading, loaded, failure }

enum FoodFormSubmitStatus { idle, submitting, success, failure }

class FoodFormState extends Equatable {
  const FoodFormState({
    this.itemId,
    this.loadStatus = FoodFormLoadStatus.idle,
    this.submitStatus = FoodFormSubmitStatus.idle,
    this.name = '',
    this.category,
    this.quantity = 1,
    this.unit = FoodUnit.pcs,
    this.storage = StorageLocation.fridge,
    this.purchaseDate,
    this.expiryDate,
    this.imageUrl,
    this.isPartlyUsed = false,
    this.message,
    this.fieldErrors = const {},
    this.submittedItem,
  });

  final String? itemId;
  final FoodFormLoadStatus loadStatus;
  final FoodFormSubmitStatus submitStatus;
  final String name;
  final FoodCategory? category;
  final num quantity;
  final FoodUnit? unit;
  final StorageLocation? storage;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final String? imageUrl;
  final bool isPartlyUsed;
  final String? message;
  final Map<String, List<String>> fieldErrors;
  final FoodItemEntity? submittedItem;

  bool get isEdit => itemId != null;

  bool get isSubmitting => submitStatus == FoodFormSubmitStatus.submitting;

  bool get isInitialLoading =>
      isEdit && loadStatus == FoodFormLoadStatus.loading;

  String? fieldError(String apiField) {
    final errors = fieldErrors[apiField];
    if (errors == null || errors.isEmpty) return null;
    return errors.first;
  }

  FoodFormState copyWith({
    String? itemId,
    FoodFormLoadStatus? loadStatus,
    FoodFormSubmitStatus? submitStatus,
    String? name,
    FoodCategory? category,
    bool clearCategory = false,
    num? quantity,
    FoodUnit? unit,
    bool clearUnit = false,
    StorageLocation? storage,
    bool clearStorage = false,
    DateTime? purchaseDate,
    bool clearPurchaseDate = false,
    DateTime? expiryDate,
    bool clearExpiryDate = false,
    String? imageUrl,
    bool clearImageUrl = false,
    bool? isPartlyUsed,
    String? message,
    bool clearMessage = false,
    Map<String, List<String>>? fieldErrors,
    FoodItemEntity? submittedItem,
    bool clearSubmittedItem = false,
  }) {
    return FoodFormState(
      itemId: itemId ?? this.itemId,
      loadStatus: loadStatus ?? this.loadStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      name: name ?? this.name,
      category: clearCategory ? null : (category ?? this.category),
      quantity: quantity ?? this.quantity,
      unit: clearUnit ? null : (unit ?? this.unit),
      storage: clearStorage ? null : (storage ?? this.storage),
      purchaseDate:
          clearPurchaseDate ? null : (purchaseDate ?? this.purchaseDate),
      expiryDate: clearExpiryDate ? null : (expiryDate ?? this.expiryDate),
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      isPartlyUsed: isPartlyUsed ?? this.isPartlyUsed,
      message: clearMessage ? null : (message ?? this.message),
      fieldErrors: fieldErrors ?? this.fieldErrors,
      submittedItem:
          clearSubmittedItem ? null : (submittedItem ?? this.submittedItem),
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        loadStatus,
        submitStatus,
        name,
        category,
        quantity,
        unit,
        storage,
        purchaseDate,
        expiryDate,
        imageUrl,
        isPartlyUsed,
        message,
        fieldErrors,
        submittedItem,
      ];
}
