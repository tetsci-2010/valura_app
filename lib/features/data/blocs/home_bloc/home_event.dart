part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class FetchProducts extends HomeEvent {
  final Sort? sort;

  const FetchProducts({this.sort});
}

final class DeleteProduct extends HomeEvent {
  final int? id;

  const DeleteProduct({this.id});
  @override
  List<Object?> get props => [id];
}
