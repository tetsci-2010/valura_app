part of 'product_details_bloc.dart';

sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailsInitial extends ProductDetailsState {}

final class FetchingProductDetails extends ProductDetailsState {}

final class FetchProductDetailsFailure extends ProductDetailsState {
  final String errorMessage;
  final String? statusCode;

  const FetchProductDetailsFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

final class FetchProductDetailsSuccess extends ProductDetailsState {
  final List<ItemModel> details;

  const FetchProductDetailsSuccess({required this.details});

  @override
  List<Object?> get props => [details];
}

final class DeletingProductDetail extends ProductDetailsState {}

final class DeleteProductDetailSuccess extends ProductDetailsState {
  final String message;

  const DeleteProductDetailSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class DeleteProductDetailFailure extends ProductDetailsState {
  final String errorMessage;
  final String? statusCode;

  const DeleteProductDetailFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}
