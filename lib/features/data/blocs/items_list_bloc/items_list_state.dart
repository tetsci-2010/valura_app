part of 'items_list_bloc.dart';

sealed class ItemsListState extends Equatable {
  const ItemsListState();

  @override
  List<Object?> get props => [];
}

final class ItemsListInitial extends ItemsListState {}

//* Fetch
final class FetchingItemsList extends ItemsListState {}

final class FetchItemsListSuccess extends ItemsListState {
  final List<ItemModel> items;

  const FetchItemsListSuccess({required this.items});

  @override
  List<Object?> get props => [items];
}

final class FetchItemsListFailure extends ItemsListState {
  final String errorMessage;
  final String? statusCode;

  const FetchItemsListFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

//* Delete
final class DeletingItem extends ItemsListState {}

final class DeleteItemSuccess extends ItemsListState {}

final class DeleteItemFailure extends ItemsListState {
  final String errorMessage;
  final String? statusCode;

  const DeleteItemFailure({required this.errorMessage, this.statusCode});

  @override
  List<Object?> get props => [errorMessage, statusCode];
}

//* Edit
final class EditingItem extends ItemsListState {}

final class EditItemSuccess extends ItemsListState {
  final ItemModel item;

  const EditItemSuccess({required this.item});

  @override
  List<Object?> get props => [item];
}

final class EditItemFailure extends ItemsListState {
  final String errorMessage;
  final String? statusCode;

  const EditItemFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}
