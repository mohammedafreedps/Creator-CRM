import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:creator_tracker/exception/api_exceptions.dart';
import 'package:http/http.dart' as http;
import '../models/creator.dart';

class CreatorApiService {
  final String baseUrl;
  final Duration timeout;
  final http.Client? client;

  CreatorApiService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.client,
  });

  http.Client get _client => client ?? http.Client();

  // ==================== GET: Fetch all creators ====================
  Future<List<Creator>> getAllCreators() async {
    try {
      final response = await _client
          .get(
            Uri.parse(baseUrl),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      final data = _handleResponse(response);

      if (data is! List) {
        throw ApiException('Invalid response format: Expected List');
      }

      return data
          .map((json) => Creator.fromJson(json as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw NetworkException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Request timeout. Please try again.');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch creators: $e');
    }
  }

  // ==================== POST: Create new creator ====================
  Future<Creator> createCreator(Creator creator) async {
    _validateCreatorName(creator.creatorName);

    try {
      final payload = {
        'action': 'add',
        ...creator.toJson(),
      };

      final response = await _client
          .post(
            Uri.parse(baseUrl),
            headers: _getHeaders(),
            body: json.encode(payload),
          )
          .timeout(timeout);

      final data = _handleResponse(response);

      if (data is! Map<String, dynamic>) {
        throw ApiException('Invalid response format: Expected Map');
      }

      final rowNumber = data['rowNumber'] as int?;
      return creator.copyWith(rowNumber: rowNumber);
    } on SocketException {
      throw NetworkException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Request timeout. Please try again.');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to create creator: $e');
    }
  }

  // ==================== POST: Update creator ====================
  Future<Creator> updateCreator(Creator creator) async {
    if (creator.rowNumber == null) {
      throw ValidationException('Row number is required for update');
    }
    _validateCreatorName(creator.creatorName);

    try {
      final payload = {
        'action': 'update',
        ...creator.toJson(),
      };

      final response = await _client
          .post(
            Uri.parse(baseUrl),
            headers: _getHeaders(),
            body: json.encode(payload),
          )
          .timeout(timeout);

      _handleResponse(response);
      return creator;
    } on SocketException {
      throw NetworkException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Request timeout. Please try again.');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to update creator: $e');
    }
  }

  // ==================== POST: Delete creator ====================
  Future<void> deleteCreator(int rowNumber) async {
    if (rowNumber < 3) {
      throw ValidationException('Invalid row number: must be >= 3');
    }

    try {
      final payload = {
        'action': 'delete',
        'rowNumber': rowNumber,
      };

      final response = await _client
          .post(
            Uri.parse(baseUrl),
            headers: _getHeaders(),
            body: json.encode(payload),
          )
          .timeout(timeout);

      _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Request timeout. Please try again.');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to delete creator: $e');
    }
  }

  // ==================== PRIVATE HELPERS ====================

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  dynamic _handleResponse(http.Response response) {
    // Parse JSON
    dynamic responseData;
    try {
      responseData = json.decode(response.body);
    } catch (e) {
      throw ApiException('Invalid JSON response: ${response.body}');
    }

    // Check for API error field
    if (responseData is Map && responseData.containsKey('error')) {
      final errorMsg = responseData['error'] as String;
      throw _createExceptionFromStatusCode(response.statusCode, errorMsg);
    }

    // Handle HTTP status codes
    switch (response.statusCode) {
      case 200:
      case 201:
        return responseData;

      case 400:
        throw ValidationException(
          _extractErrorMessage(responseData) ?? 'Bad request',
        );

      case 401:
        throw UnauthorizedException();

      case 403:
        throw ApiException('Forbidden: Access denied', statusCode: 403);

      case 404:
        throw NotFoundException(
          _extractErrorMessage(responseData) ?? 'Resource not found',
        );

      case 500:
      case 502:
      case 503:
        throw ServerException(
          'Server error: ${_extractErrorMessage(responseData) ?? 'Unknown error'}',
          statusCode: response.statusCode,
        );

      default:
        throw ApiException(
          'HTTP ${response.statusCode}: ${_extractErrorMessage(responseData)}',
          statusCode: response.statusCode,
        );
    }
  }

  ApiException _createExceptionFromStatusCode(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        return ValidationException(message);
      case 401:
        return UnauthorizedException();
      case 404:
        return NotFoundException(message);
      case 500:
      case 502:
      case 503:
        return ServerException(message, statusCode: statusCode);
      default:
        return ApiException(message, statusCode: statusCode);
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map) {
      return data['error'] as String? ??
          data['message'] as String? ??
          data.toString();
    }
    return data?.toString();
  }

  void _validateCreatorName(String name) {
    if (name.trim().isEmpty) {
      throw ValidationException('Creator name cannot be empty');
    }
  }

  void dispose() {
    client?.close();
  }
}