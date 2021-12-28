import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class LikeBloc extends Bloc<LikeEvent, LikesState> {
  final Set<String> _likes = {};
  LikeBloc() : super(Likes(likes: {}));

  @override
  Stream<LikesState> mapEventToState(
    LikeEvent event,
  ) async* {
    if (event is Like) {
      _likes.add(event.id);
      yield Likes(likes: _likes);
    } else if (event is Dislike) {
      _likes.remove(event.id);
      yield Likes(likes: _likes);
    }
  }
}
