part of 'edit_item_bloc.dart';

sealed class EditItemEvent extends Equatable {
  const EditItemEvent();

  @override
  List<Object?> get props => [];
}

final class EditProductDetails extends EditItemEvent {
  final int id;

  const EditProductDetails({required this.id});
  @override
  List<Object?> get props => [id];
}

final class UpdateProductDetails extends EditItemEvent {
  final ItemModel item;
  final int pId;

  const UpdateProductDetails({required this.item, required this.pId});

  @override
  List<Object?> get props => [item, pId];
}

final class UpdateItem extends EditItemEvent {
  final ItemModel item;

  const UpdateItem({required this.item});

  @override
  List<Object?> get props => [item];
}

final class EditItem extends EditItemEvent {
  final int id;

  const EditItem({required this.id});
  @override
  List<Object?> get props => [id];
}
