import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/enums/sort.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/services/item_service.dart';

part 'items_list_event.dart';
part 'items_list_state.dart';

class ItemsListBloc extends Bloc<ItemsListEvent, ItemsListState> {
  final ItemService itemService;
  static Sort? sort;
  ItemsListBloc(this.itemService) : super(ItemsListInitial()) {
    on<FetchItemsList>(_onFetchItemsList);
    on<DeleteItem>(_onDeleteItem);
  }

  _onFetchItemsList(FetchItemsList event, Emitter<ItemsListState> emit) async {
    try {
      emit(FetchingItemsList());
      final result = await itemService.fetchItems(event.sort);
      sort = event.sort;
      emit(FetchItemsListSuccess(items: result));
    } on AppException catch (e) {
      emit(FetchItemsListFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(FetchItemsListFailure(errorMessage: e.toString()));
    }
  }

  _onDeleteItem(DeleteItem event, Emitter<ItemsListState> emit) async {
    try {
      emit(DeletingItem());
      await itemService.deleteItem(event.id);
      add(FetchItemsList());
      emit(DeleteItemSuccess());
    } on AppException catch (e) {
      emit(DeleteItemFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(DeleteItemFailure(errorMessage: e.toString()));
    }
  }
}
