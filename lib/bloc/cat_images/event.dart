part of 'bloc.dart';

@immutable
abstract class CatsEvent {}

class InitialCats extends CatsEvent {}

class LoadNewImages extends CatsEvent {}
