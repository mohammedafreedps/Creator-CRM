part of 'show_all_creator_cubit.dart';

sealed class ShowAllCreatorState extends Equatable {
  const ShowAllCreatorState();

  @override
  List<Object> get props => [];
}

final class ShowAllCreatorInitial extends ShowAllCreatorState {}

final class CreatorListLoading extends ShowAllCreatorState {}

class CreatorListLoaded extends ShowAllCreatorState {

  final List<CreatorWithOutreach> creators;

  CreatorListLoaded(this.creators);

}

class CreatorListEmpty extends ShowAllCreatorState {}

final class CreatorListError extends ShowAllCreatorState {
  final String message;

  const CreatorListError(this.message);
}