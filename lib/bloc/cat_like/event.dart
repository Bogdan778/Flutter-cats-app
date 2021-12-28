part of 'bloc.dart';

@immutable
abstract class LikeEvent {}

class Like extends LikeEvent {
  final String id;

  Like({required this.id});
}

class Dislike extends LikeEvent {
  final String id;

  Dislike({required this.id});
}
