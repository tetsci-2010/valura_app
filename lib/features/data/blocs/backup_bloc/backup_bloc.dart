import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/models/backup_model.dart';
import 'package:valura/features/data/services/item_service.dart';

part 'backup_event.dart';
part 'backup_state.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final ItemService itemService;
  BackupBloc(this.itemService) : super(BackupInitial()) {
    on<CreateBackup>(_onCreateBackup);
    on<FetchBackups>(_onFetchBackups);
    on<RestoreBackup>(_onRestoreBackup);
  }

  _onCreateBackup(CreateBackup event, Emitter<BackupState> emit) async {
    try {
      emit(CreatingBackup());
      final result = await itemService.backupDB();
      emit(CreateBackupSuccess(message: result));
    } on AppException catch (e) {
      emit(CreateBackupFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(CreateBackupFailure(errorMessage: e.toString()));
    }
  }

  _onFetchBackups(FetchBackups event, Emitter<BackupState> emit) async {
    try {
      emit(FetchingBackups());
      final result = await itemService.fetchBackups();
      emit(FetchBackupsSuccess(backups: result));
    } on AppException catch (e) {
      emit(FetchBackupsFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(FetchBackupsFailure(errorMessage: e.toString()));
    }
  }

  _onRestoreBackup(RestoreBackup event, Emitter<BackupState> emit) async {
    try {
      emit(RestoringBackup());
      final result = await itemService.restoreBackup();
      emit(RestoreBackupSuccess(message: result));
    } on AppException catch (e) {
      emit(RestoreBackupFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(RestoreBackupFailure(errorMessage: e.toString()));
    }
  }
}
