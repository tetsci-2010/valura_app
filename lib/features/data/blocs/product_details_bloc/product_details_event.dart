part of 'product_details_bloc.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchProductDetails extends ProductDetailsEvent {
  final int id;

  const FetchProductDetails({required this.id});

  @override
  List<Object?> get props => [id];
}
