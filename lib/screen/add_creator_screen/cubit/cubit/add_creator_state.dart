part of 'add_creator_cubit.dart';

sealed class AddCreatorState extends Equatable {
  const AddCreatorState();

  @override
  List<Object> get props => [];
}

final class AddCreatorInitial extends AddCreatorState {}

final class CreatorSaveInitial extends AddCreatorState {}

final class CreatorSaveLoading extends AddCreatorState {}

final class CreatorSaveSuccess extends AddCreatorState {
  final int creatorId;

  const CreatorSaveSuccess(this.creatorId);
}

final class CreatorSaveError extends AddCreatorState {
  final String message;

  const CreatorSaveError(this.message);
}