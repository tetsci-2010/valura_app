part of 'backup_bloc.dart';

sealed class BackupState extends Equatable {
  const BackupState();

  @override
  List<Object?> get props => [];
}

final class BackupInitial extends BackupState {}

final class CreatingBackup extends BackupState {}

final class CreateBackupSuccess extends BackupState {
  final String message;

  const CreateBackupSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CreateBackupFailure extends BackupState {
  final String errorMessage;
  final String? statusCode;

  const CreateBackupFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

final class FetchingBackups extends BackupState {}

final class FetchBackupsSuccess extends BackupState {
  final List<BackupModel> backups;

  const FetchBackupsSuccess({required this.backups});

  @override
  List<Object?> get props => [backups];
}

final class FetchBackupsFailure extends BackupState {
  final String errorMessage;
  final String? statusCode;

  const FetchBackupsFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

final class RestoringBackup extends BackupState {}

final class RestoreBackupSuccess extends BackupState {
  final String message;

  const RestoreBackupSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class RestoreBackupFailure extends BackupState {
  final String errorMessage;
  final String? statusCode;

  const RestoreBackupFailure({required this.errorMessage, this.statusCode});

  @override
  List<Object?> get props => [errorMessage, statusCode];
}
