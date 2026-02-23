import 'package:creator_tracker/models/creator.dart';
import 'package:equatable/equatable.dart';

/// Base abstract state for Creator operations
abstract class CreatorState extends Equatable {
  const CreatorState();

  @override
  List<Object?> get props => [];
}

// ==================== INITIAL STATE ====================

/// Initial state when the cubit is first created
class CreatorInitial extends CreatorState {
  const CreatorInitial();

  @override
  String toString() => 'CreatorInitial';
}

// ==================== LOADING STATES ====================

/// General loading state (used for initial fetch)
class CreatorLoading extends CreatorState {
  const CreatorLoading();

  @override
  String toString() => 'CreatorLoading';
}

/// Loading state while creating a new creator
class CreatorCreating extends CreatorState {
  final List<Creator> creators;

  const CreatorCreating(this.creators);

  @override
  List<Object?> get props => [creators];

  @override
  String toString() => 'CreatorCreating { creators: ${creators.length} }';
}

/// Loading state while updating a creator
class CreatorUpdating extends CreatorState {
  final List<Creator> creators;

  const CreatorUpdating(this.creators);

  @override
  List<Object?> get props => [creators];

  @override
  String toString() => 'CreatorUpdating { creators: ${creators.length} }';
}

/// Loading state while deleting a creator
class CreatorDeleting extends CreatorState {
  final List<Creator> creators;

  const CreatorDeleting(this.creators);

  @override
  List<Object?> get props => [creators];

  @override
  String toString() => 'CreatorDeleting { creators: ${creators.length} }';
}

// ==================== SUCCESS STATES ====================

/// Successfully loaded creators list
class CreatorLoaded extends CreatorState {
  final List<Creator> creators;

  const CreatorLoaded(this.creators);

  @override
  List<Object?> get props => [creators];

  /// Check if list is empty
  bool get isEmpty => creators.isEmpty;

  /// Check if list has data
  bool get isNotEmpty => creators.isNotEmpty;

  /// Get total count
  int get count => creators.length;

  @override
  String toString() => 'CreatorLoaded { creators: ${creators.length} }';
}

/// Successfully completed an operation (add/update/delete)
class CreatorOperationSuccess extends CreatorState {
  final String message;
  final List<Creator> creators;

  const CreatorOperationSuccess({
    required this.message,
    required this.creators,
  });

  @override
  List<Object?> get props => [message, creators];

  @override
  String toString() =>
      'CreatorOperationSuccess { message: $message, creators: ${creators.length} }';
}

// ==================== ERROR STATE ====================

/// Error state with optional cached data
class CreatorError extends CreatorState {
  final String message;
  final List<Creator> creators;
  final Exception? exception;

  const CreatorError({
    required this.message,
    this.creators = const [],
    this.exception,
  });

  @override
  List<Object?> get props => [message, creators, exception];

  /// Check if we have cached data to show
  bool get hasCachedData => creators.isNotEmpty;

  /// Check if error is critical (no cached data)
  bool get isCritical => creators.isEmpty;

  @override
  String toString() =>
      'CreatorError { message: $message, creators: ${creators.length} }';
}

// ==================== HELPER EXTENSIONS ====================

/// Extension to check state types easily
extension CreatorStateX on CreatorState {
  /// Is any loading state
  bool get isLoading =>
      this is CreatorLoading ||
      this is CreatorCreating ||
      this is CreatorUpdating ||
      this is CreatorDeleting;

  /// Is operation in progress (not initial loading)
  bool get isOperating =>
      this is CreatorCreating ||
      this is CreatorUpdating ||
      this is CreatorDeleting;

  /// Has data to display
  bool get hasData {
    if (this is CreatorLoaded) return (this as CreatorLoaded).isNotEmpty;
    if (this is CreatorOperationSuccess) {
      return (this as CreatorOperationSuccess).creators.isNotEmpty;
    }
    if (this is CreatorError) return (this as CreatorError).hasCachedData;
    if (this is CreatorCreating) return (this as CreatorCreating).creators.isNotEmpty;
    if (this is CreatorUpdating) return (this as CreatorUpdating).creators.isNotEmpty;
    if (this is CreatorDeleting) return (this as CreatorDeleting).creators.isNotEmpty;
    return false;
  }

  /// Get creators list if available
  List<Creator> get creators {
    if (this is CreatorLoaded) return (this as CreatorLoaded).creators;
    if (this is CreatorOperationSuccess) {
      return (this as CreatorOperationSuccess).creators;
    }
    if (this is CreatorError) return (this as CreatorError).creators;
    if (this is CreatorCreating) return (this as CreatorCreating).creators;
    if (this is CreatorUpdating) return (this as CreatorUpdating).creators;
    if (this is CreatorDeleting) return (this as CreatorDeleting).creators;
    return [];
  }
}