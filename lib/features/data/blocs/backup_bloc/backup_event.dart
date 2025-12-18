part of 'backup_bloc.dart';

sealed class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => [];
}

final class CreateBackup extends BackupEvent {}

final class FetchBackups extends BackupEvent {}

final class RestoreBackup extends BackupEvent {}
