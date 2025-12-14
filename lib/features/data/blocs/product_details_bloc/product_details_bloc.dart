import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/services/item_service.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ItemService itemService;
  ProductDetailsBloc(this.itemService) : super(ProductDetailsInitial()) {
    on<FetchProductDetails>(_onFetchProductDetails);
    on<DeleteProductDetail>(_onDeleteProductDetail);
  }

  _onFetchProductDetails(FetchProductDetails event, Emitter<ProductDetailsState> emit) async {
    try {
      emit(FetchingProductDetails());
      final result = await itemService.fetchProductDetails(event.id);
      emit(FetchProductDetailsSuccess(details: result));
    } on AppException catch (e) {
      emit(FetchProductDetailsFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(FetchProductDetailsFailure(errorMessage: e.toString()));
    }
  }

  _onDeleteProductDetail(DeleteProductDetail event, Emitter<ProductDetailsState> emit) async {
    try {
      emit(DeletingProductDetail());
      final result = await itemService.deleteProductDetail(id: event.id, pId: event.pId);
      add(FetchProductDetails(id: event.pId));
      emit(DeleteProductDetailSuccess(message: result));
    } on AppException catch (e) {
      emit(DeleteProductDetailFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(DeleteProductDetailFailure(errorMessage: e.toString()));
    }
  }
}
