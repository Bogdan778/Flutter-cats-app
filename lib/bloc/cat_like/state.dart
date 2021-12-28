part of 'bloc.dart';

@immutable
abstract class LikesState {}

class Likes extends LikesState {
  final Set<String> likes;

  Likes({required this.likes});
}
