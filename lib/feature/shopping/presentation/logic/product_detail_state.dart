import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/shopping/domain/entities/catalog_product_entity.dart';

enum ProductDetailStatus { loading, success, failure }

enum ProductDetailActionStatus {
  idle,
  working,
  addedToCart,
  addedToList,
  failure,
}

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.loading,
    this.product,
    this.quantity = 1,
    this.message,
    this.actionStatus = ProductDetailActionStatus.idle,
  });

  final ProductDetailStatus status;
  final CatalogProductEntity? product;
  final num quantity;
  final String? message;
  final ProductDetailActionStatus actionStatus;

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    CatalogProductEntity? product,
    num? quantity,
    String? message,
    ProductDetailActionStatus? actionStatus,
    bool clearMessage = false,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      message: clearMessage ? null : (message ?? this.message),
      actionStatus: actionStatus ?? this.actionStatus,
    );
  }

  @override
  List<Object?> get props => [status, product, quantity, message, actionStatus];
}
