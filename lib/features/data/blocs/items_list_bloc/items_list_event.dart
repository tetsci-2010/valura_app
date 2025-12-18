part of 'items_list_bloc.dart';

sealed class ItemsListEvent extends Equatable {
  const ItemsListEvent();

  @override
  List<Object?> get props => [];
}

final class FetchItemsList extends ItemsListEvent {
  final Sort? sort;

  const FetchItemsList({this.sort});
  @override
  List<Object?> get props => [sort];
}

final class DeleteItem extends ItemsListEvent {
  final int? id;

  const DeleteItem({this.id});
  @override
  List<Object?> get props => [id];
}
