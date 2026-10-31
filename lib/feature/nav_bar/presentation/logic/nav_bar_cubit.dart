import 'package:flutter_bloc/flutter_bloc.dart';

class NavBarCubit extends Cubit<int> {
  NavBarCubit() : super(0);

  void select(int index) {
    if (index == state) return;
    emit(index);
  }
}
