part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class FetchingProducts extends HomeState {}

final class FetchProductsSuccess extends HomeState {
  final List<ProductModel> products;

  const FetchProductsSuccess({required this.products});
  @override
  List<Object?> get props => [products];
}

final class FetchProductsFailure extends HomeState {
  final String errorMessage;
  final String? statusCode;

  const FetchProductsFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}
