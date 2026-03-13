part of 'delete_creator_cubit.dart';

sealed class DeleteCreatorState extends Equatable {
  const DeleteCreatorState();

  @override
  List<Object> get props => [];
}

final class DeleteCreatorInitial extends DeleteCreatorState {}

class DeleteCreatorLoading extends DeleteCreatorState {}

class DeleteCreatorSuccess extends DeleteCreatorState {}

class DeleteCreatorError extends DeleteCreatorState {
  final String message;

  const DeleteCreatorError(this.message);
}