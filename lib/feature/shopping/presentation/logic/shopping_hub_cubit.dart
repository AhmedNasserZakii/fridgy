import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_hub_tab.dart';

class ShoppingHubCubit extends Cubit<ShoppingHubTab> {
  ShoppingHubCubit() : super(ShoppingHubTab.list);

  void select(ShoppingHubTab tab) => emit(tab);
}
