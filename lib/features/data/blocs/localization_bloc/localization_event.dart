part of 'localization_bloc.dart';

sealed class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends LocalizationEvent {
  final Language language;

  const ChangeLanguage({required this.language});

  @override
  List<Object> get props => [language];
}

class GetLanguage extends LocalizationEvent {
  
}
