import 'package:bloc/bloc.dart';
import 'package:creator_tracker/database/base_repository.dart';
import 'package:creator_tracker/database/db_tables.dart';
import 'package:equatable/equatable.dart';

part 'delete_creator_state.dart';

class DeleteCreatorCubit extends Cubit<DeleteCreatorState> {
  DeleteCreatorCubit() : super(DeleteCreatorInitial());
  
  Future<void> deleteCreator(int id) async {
    final baseRepo = BaseRepository(DbTables.creators);
    try {
      emit(DeleteCreatorLoading());

      await baseRepo.delete(id);

      emit(DeleteCreatorSuccess());
    } catch (e) {
      emit(DeleteCreatorError(e.toString()));
    }
  }
}
