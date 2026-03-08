import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'show_all_creator_state.dart';

class ShowAllCreatorCubit extends Cubit<ShowAllCreatorState> {
  ShowAllCreatorCubit() : super(ShowAllCreatorInitial());
}
