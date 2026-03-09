import 'package:bloc/bloc.dart';
import 'package:creator_tracker/database/database_service.dart';
import 'package:creator_tracker/models/creator_model.dart';
import 'package:creator_tracker/models/outreach_model.dart';
import 'package:equatable/equatable.dart';

part 'show_all_creator_state.dart';

class CreatorWithOutreach {

  final Creator creator;
  final Outreach? outreach;

  CreatorWithOutreach({
    required this.creator,
    this.outreach,
  });

}

class ShowAllCreatorCubit extends Cubit<ShowAllCreatorState> {

  ShowAllCreatorCubit() : super(ShowAllCreatorInitial());

  Future<void> loadCreators() async {

    try {

      emit(CreatorListLoading());

      final db = await DatabaseService.database;

      final creatorRows = await db.query(
        "creators",
        orderBy: "created_at DESC",
      );

      if (creatorRows.isEmpty) {
        emit(CreatorListEmpty());
        return;
      }

      List<CreatorWithOutreach> data = [];

      for (final row in creatorRows) {

        final creator = Creator.fromMap(row);

        final outreachRows = await db.query(
          "outreach",
          where: "creator_id=?",
          whereArgs: [creator.id],
        );

        Outreach? outreach;

        if (outreachRows.isNotEmpty) {
          outreach = Outreach.fromMap(outreachRows.first);
        }

        data.add(
          CreatorWithOutreach(
            creator: creator,
            outreach: outreach,
          ),
        );

      }

      emit(CreatorListLoaded(data));

    } catch (e, stack) {

      print("Creator Load Error: $e");
      print(stack);

      emit(CreatorListError("Failed to load creators"));

    }

  }

  Future<void> refreshCreators() async {
    await loadCreators();
  }

}