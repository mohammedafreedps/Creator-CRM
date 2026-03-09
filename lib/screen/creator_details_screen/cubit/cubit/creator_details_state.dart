part of 'creator_details_cubit.dart';

sealed class CreatorDetailsState extends Equatable {
  const CreatorDetailsState();

  @override
  List<Object> get props => [];
}

final class CreatorDetailsInitial extends CreatorDetailsState {}

final class CreatorDetailLoading extends CreatorDetailsState {}

final class CreatorDetailLoaded extends CreatorDetailsState {

  final CreatorFullDetail data;

  const CreatorDetailLoaded(this.data);

}

final class CreatorDetailError extends CreatorDetailsState {

  final String message;

  const CreatorDetailError(this.message);

}