import 'package:creator_tracker/exception/api_exceptions.dart';
import 'package:creator_tracker/service/creator_api_service.dart';

import '../models/creator.dart';

class CreatorRepository {
  final CreatorApiService _apiService;

  CreatorRepository(this._apiService);

  /// Fetch all creators
  Future<List<Creator>> fetchAllCreators() async {
    try {
      final t = await _apiService.getAllCreators();
      print(t);
      // return await _apiService.getAllCreators();
      return t;

    } catch (e) {
      _logError('fetchAllCreators', e);
      rethrow;
    }
  }

  /// Create new creator
  Future<Creator> createCreator(Creator creator) async {
    try {
      return await _apiService.createCreator(creator);
    } catch (e) {
      _logError('createCreator', e);
      rethrow;
    }
  }

  /// Update existing creator
  Future<Creator> updateCreator(Creator creator) async {
    try {
      return await _apiService.updateCreator(creator);
    } catch (e) {
      _logError('updateCreator', e);
      rethrow;
    }
  }

  /// Delete creator by row number
  Future<void> deleteCreator(int rowNumber) async {
    try {
      await _apiService.deleteCreator(rowNumber);
    } catch (e) {
      _logError('deleteCreator', e);
      rethrow;
    }
  }

  /// Centralized error logging
  void _logError(String operation, dynamic error) {
    if (error is NetworkException) {
      print('❌ [$operation] Network Error: ${error.message}');
    } else if (error is ValidationException) {
      print('⚠️ [$operation] Validation Error: ${error.message}');
    } else if (error is ServerException) {
      print('🔥 [$operation] Server Error: ${error.message}');
    } else if (error is ApiException) {
      print('⚠️ [$operation] API Error: ${error.message}');
    } else {
      print('💥 [$operation] Unexpected Error: $error');
    }
  }
}