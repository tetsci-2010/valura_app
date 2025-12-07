import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/services/item_service.dart';

part 'create_item_event.dart';
part 'create_item_state.dart';

class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  final ItemService itemService;
  CreateItemBloc(this.itemService) : super(CreateItemInitial()) {
    on<CreateItem>(_onCreateItem);
  }

  _onCreateItem(CreateItem event, Emitter<CreateItemState> emit) async {
    try {
      emit(CreatingItem());
      final result = await itemService.storeItem(event.itemModel);
      emit(CreateItemSuccess(result));
    } on AppException catch (e) {
      emit(CreateItemFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(CreateItemFailure(errorMessage: e.toString()));
    }
  }
}
