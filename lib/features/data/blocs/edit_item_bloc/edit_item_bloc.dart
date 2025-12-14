import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/services/item_service.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  final ItemService itemService;
  EditItemBloc(this.itemService) : super(EditItemInitial()) {
    on<EditItem>(_onEditItem);
  }

  _onEditItem(EditItem event, Emitter<EditItemState> emit) async {
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

}
