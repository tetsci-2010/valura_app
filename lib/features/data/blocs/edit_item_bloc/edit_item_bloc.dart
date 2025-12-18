import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/blocs/items_list_bloc/items_list_bloc.dart';
import 'package:valura/features/data/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/services/item_service.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  final ItemService itemService;
  final ProductDetailsBloc pDetailsBloc;
  final ItemsListBloc itemsListBloc;
  EditItemBloc(this.itemService, this.pDetailsBloc, this.itemsListBloc) : super(EditItemInitial()) {
    on<EditProductDetails>(_onEditProductDetails);
    on<UpdateProductDetails>(_onUpdateDropDownItems);
    on<UpdateItem>(_onUpdateItem);
    on<EditItem>(_onEditItem);
  }

  _onEditProductDetails(EditProductDetails event, Emitter<EditItemState> emit) async {
    try {
      emit(EditingItem());
      final result = await itemService.editProductDetails(event.id);
      emit(EditItemSuccess(item: result));
    } on AppException catch (e) {
      emit(EditItemFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(EditItemFailure(errorMessage: e.toString()));
    }
  }

  _onUpdateDropDownItems(UpdateProductDetails event, Emitter<EditItemState> emit) async {
    try {
      emit(UpdatingProductDetails());
      final result = await itemService.updateProductDetail(item: event.item, pId: event.pId);
      pDetailsBloc.add(FetchProductDetails(id: event.item.id));
      emit(UpdateProductDetailsSuccess(message: result));
    } on AppException catch (e) {
      emit(UpdateProductDetailsFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(UpdateProductDetailsFailure(errorMessage: e.toString()));
    }
  }

  _onUpdateItem(UpdateItem event, Emitter<EditItemState> emit) async {
    try {
      emit(UpdatingItem());
      await itemService.updateItem(event.item);
      itemsListBloc.add(FetchItemsList());
      emit(UpdateItemSuccess());
    } on AppException catch (e) {
      emit(UpdateItemFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(UpdateItemFailure(errorMessage: e.toString()));
    }
  }

  _onEditItem(EditItem event, Emitter<EditItemState> emit) async {
    try {
      emit(EditingItem());
      final result = await itemService.editItem(event.id);
      emit(EditItemSuccess(item: result));
    } on AppException catch (e) {
      emit(EditItemFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(EditItemFailure(errorMessage: e.toString()));
    }
  }
}
