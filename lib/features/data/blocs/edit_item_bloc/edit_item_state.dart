part of 'edit_item_bloc.dart';

sealed class EditItemState extends Equatable {
  const EditItemState();

  @override
  List<Object?> get props => [];
}

final class EditItemInitial extends EditItemState {}

final class EditingItem extends EditItemState {}

final class EditItemSuccess extends EditItemState {
  final ItemModel? item;

  const EditItemSuccess({required this.item});

  @override
  List<Object?> get props => [item];
}

final class EditItemFailure extends EditItemState {
  final String errorMessage;
  final String? statusCode;

  const EditItemFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

final class UpdatingProductDetails extends EditItemState {}

final class UpdateProductDetailsSuccess extends EditItemState {
  final String message;

  const UpdateProductDetailsSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class UpdateProductDetailsFailure extends EditItemState {
  final String errorMessage;
  final String? statusCode;

  const UpdateProductDetailsFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

final class UpdatingItem extends EditItemState {}

final class UpdateItemSuccess extends EditItemState {}

final class UpdateItemFailure extends EditItemState {
  final String errorMessage;
  final String? statusCode;

  const UpdateItemFailure({required this.errorMessage, this.statusCode});

  @override
  List<Object?> get props => [errorMessage, statusCode];
}
