part of 'create_item_bloc.dart';

sealed class CreateItemEvent extends Equatable {
  const CreateItemEvent();

  @override
  List<Object?> get props => [];
}

class CreateItem extends CreateItemEvent {
  final ItemModel itemModel;

  const CreateItem({required this.itemModel});

  @override
  List<Object?> get props => [itemModel];
}
