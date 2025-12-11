part of 'create_item_bloc.dart';

sealed class CreateItemState extends Equatable {
  const CreateItemState();

  @override
  List<Object?> get props => [];
}

final class CreateItemInitial extends CreateItemState {}

final class CreatingItem extends CreateItemState {}

final class CreateItemSuccess extends CreateItemState {
  final String message;

  const CreateItemSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class CreateItemFailure extends CreateItemState {
  final String errorMessage;
  final String? statusCode;

  const CreateItemFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

final class CreatingProduct extends CreateItemState {}

final class CreateProductSuccess extends CreateItemState {
  final String message;

  const CreateProductSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

final class CreateProductFailure extends CreateItemState {
  final String errorMessage;
  final String? statusCode;

  const CreateProductFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}
