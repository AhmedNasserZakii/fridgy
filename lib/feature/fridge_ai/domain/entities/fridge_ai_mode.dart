enum FridgeAiMode {
  addFood,
  useFood;

  String toApi() => switch (this) {
        FridgeAiMode.addFood => 'add_food',
        FridgeAiMode.useFood => 'use_food',
      };

  static FridgeAiMode fromApi(String? value) {
    switch (value) {
      case 'use_food':
        return FridgeAiMode.useFood;
      case 'add_food':
      default:
        return FridgeAiMode.addFood;
    }
  }
}
