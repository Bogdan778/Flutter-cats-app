part of 'bloc.dart';

@immutable
abstract class CatFactsState {}

class CatFactsInitial extends CatFactsState {}

class CatsFactsLoaded extends CatFactsState {
  final List<String> facts;

  CatsFactsLoaded({required this.facts});
}
