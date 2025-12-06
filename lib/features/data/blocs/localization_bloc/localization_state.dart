part of 'localization_bloc.dart';

class LocalizationState extends Equatable {
  final Language selectedLanguage;

  const LocalizationState({Language? language})
    : selectedLanguage = language ?? Language.persian;

  @override
  List<Object> get props => [selectedLanguage];

  LocalizationState copyWith({Language? selectedLanguage}) {
    return LocalizationState(
      language: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

final class LocalizationInitial extends LocalizationState {}
