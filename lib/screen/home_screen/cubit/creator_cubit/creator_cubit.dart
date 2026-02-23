import 'package:creator_tracker/exception/api_exceptions.dart';
import 'package:creator_tracker/models/creator.dart';
import 'package:creator_tracker/repository/creator_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'creator_state.dart';

class CreatorCubit extends Cubit<CreatorState> {
  final CreatorRepository _repository;
  List<Creator> _cachedCreators = [];

  CreatorCubit(this._repository) : super(const CreatorInitial());

  /// Fetch all creators
  Future<void> fetchCreators() async {
    emit(const CreatorLoading());

    try {
      final creators = await _repository.fetchAllCreators();
      _cachedCreators = creators;
      emit(CreatorLoaded(creators));
    } on NetworkException catch (e) {
      emit(CreatorError(
        message: e.message,
        creators: _cachedCreators,
      ));
    } on ServerException catch (e) {
      emit(CreatorError(
        message: 'Server error: ${e.message}',
        creators: _cachedCreators,
      ));
    } on ApiException catch (e) {
      emit(CreatorError(
        message: e.message,
        creators: _cachedCreators,
      ));
    } catch (e) {
      emit(CreatorError(
        message: 'Unexpected error: $e',
        creators: _cachedCreators,
      ));
    }
  }

  /// Create new creator
  Future<void> createCreator(Creator creator) async {
    emit(CreatorCreating(_cachedCreators));

    try {
      final createdCreator = await _repository.createCreator(creator);
      _cachedCreators = [..._cachedCreators, createdCreator];
      
      emit(CreatorOperationSuccess(
        message: '${createdCreator.creatorName} added successfully!',
        creators: _cachedCreators,
      ));
    } on ValidationException catch (e) {
      emit(CreatorError(
        message: 'Validation error: ${e.message}',
        creators: _cachedCreators,
      ));
    } on NetworkException catch (e) {
      emit(CreatorError(
        message: e.message,
        creators: _cachedCreators,
      ));
    } on ApiException catch (e) {
      emit(CreatorError(
        message: 'Failed to add creator: ${e.message}',
        creators: _cachedCreators,
      ));
    } catch (e) {
      emit(CreatorError(
        message: 'Unexpected error: $e',
        creators: _cachedCreators,
      ));
    }
  }

  /// Update existing creator
  Future<void> updateCreator(Creator creator) async {
    emit(CreatorUpdating(_cachedCreators));

    try {
      final updatedCreator = await _repository.updateCreator(creator);
      
      _cachedCreators = _cachedCreators.map((c) {
        return c.rowNumber == updatedCreator.rowNumber ? updatedCreator : c;
      }).toList();

      emit(CreatorOperationSuccess(
        message: '${updatedCreator.creatorName} updated successfully!',
        creators: _cachedCreators,
      ));
    } on ValidationException catch (e) {
      emit(CreatorError(
        message: 'Validation error: ${e.message}',
        creators: _cachedCreators,
      ));
    } on NetworkException catch (e) {
      emit(CreatorError(
        message: e.message,
        creators: _cachedCreators,
      ));
    } on ApiException catch (e) {
      emit(CreatorError(
        message: 'Failed to update creator: ${e.message}',
        creators: _cachedCreators,
      ));
    } catch (e) {
      emit(CreatorError(
        message: 'Unexpected error: $e',
        creators: _cachedCreators,
      ));
    }
  }

  /// Delete creator
  Future<void> deleteCreator(Creator creator) async {
    if (creator.rowNumber == null) {
      emit(CreatorError(
        message: 'Cannot delete: Invalid row number',
        creators: _cachedCreators,
      ));
      return;
    }

    emit(CreatorDeleting(_cachedCreators));

    try {
      await _repository.deleteCreator(creator.rowNumber!);
      
      _cachedCreators = _cachedCreators
          .where((c) => c.rowNumber != creator.rowNumber)
          .toList();

      emit(CreatorOperationSuccess(
        message: '${creator.creatorName} deleted successfully!',
        creators: _cachedCreators,
      ));
    } on ValidationException catch (e) {
      emit(CreatorError(
        message: 'Validation error: ${e.message}',
        creators: _cachedCreators,
      ));
    } on NetworkException catch (e) {
      emit(CreatorError(
        message: e.message,
        creators: _cachedCreators,
      ));
    } on ApiException catch (e) {
      emit(CreatorError(
        message: 'Failed to delete creator: ${e.message}',
        creators: _cachedCreators,
      ));
    } catch (e) {
      emit(CreatorError(
        message: 'Unexpected error: $e',
        creators: _cachedCreators,
      ));
    }
  }

  /// Refresh creators list
  Future<void> refreshCreators() async {
    await fetchCreators();
  }

  /// Search/filter creators locally
  void filterCreators(String query) {
    if (query.isEmpty) {
      emit(CreatorLoaded(_cachedCreators));
      return;
    }

    final filtered = _cachedCreators.where((creator) {
      return creator.creatorName.toLowerCase().contains(query.toLowerCase()) ||
          creator.platform.toLowerCase().contains(query.toLowerCase()) ||
          creator.niche.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(CreatorLoaded(filtered));
  }
}