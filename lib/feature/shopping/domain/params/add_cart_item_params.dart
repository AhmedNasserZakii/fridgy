class AddCartItemParams {
  const AddCartItemParams({
    required this.catalogProductId,
    required this.quantity,
  });

  final String catalogProductId;
  final num quantity;
}
