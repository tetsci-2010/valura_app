part of 'edit_item_bloc.dart';

sealed class EditItemEvent extends Equatable {
  const EditItemEvent();

  @override
  List<Object?> get props => [];
}

final class EditItem extends EditItemEvent {
  final int id;

  const EditItem({required this.id});
  @override
  List<Object?> get props => [id];
}

