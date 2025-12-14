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
