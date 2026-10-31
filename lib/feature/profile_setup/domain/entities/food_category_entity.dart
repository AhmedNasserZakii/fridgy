import 'package:equatable/equatable.dart';

class FoodCategoryEntity extends Equatable {
  const FoodCategoryEntity({
    required this.id,
    required this.name,
    required this.emoji,
  });

  final String id;
  final String name;
  final String emoji;

  @override
  List<Object?> get props => [id, name, emoji];
}
