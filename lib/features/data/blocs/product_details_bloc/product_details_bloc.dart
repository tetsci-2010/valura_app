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
}
