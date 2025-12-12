import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/enums/sort.dart';
import 'package:valura/features/data/models/product_model.dart';
import 'package:valura/features/data/services/item_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static Sort? sort;
  final ItemService itemService;
  HomeBloc(this.itemService) : super(HomeInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<DeleteProduct>(_onDeleteProduct);
  }
  _onFetchProducts(FetchProducts event, Emitter<HomeState> emit) async {
    try {
      emit(FetchingProducts());
      sort = event.sort;
      final result = await itemService.fetchProducts(sort: event.sort);
      emit(FetchProductsSuccess(products: result));
    } on AppException catch (e) {
      emit(FetchProductsFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(FetchProductsFailure(errorMessage: e.toString()));
    }
  }

  _onDeleteProduct(DeleteProduct event, Emitter<HomeState> emit) async {
    try {
      emit(DeletingProduct());
      final result = await itemService.deleteProduct(event.id);
      add(FetchProducts());
      emit(DeleteProductSuccess(message: result));
    } on AppException catch (e) {
      emit(DeleteProductFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(DeleteProductFailure(errorMessage: e.toString()));
    }
  }
}
