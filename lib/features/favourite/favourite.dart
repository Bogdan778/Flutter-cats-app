import '/bloc/cat_like/bloc.dart';
import '/cached/cached_network_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:like_button/like_button.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LikeBloc _bloc = BlocProvider.of<LikeBloc>(context);
    return BlocBuilder<LikeBloc, LikesState>(
      builder: (context, state) {
        if (state is Likes) {
          return GridView.builder(
            padding: EdgeInsets.all(3),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1,
            ),
            itemCount: state.likes.length,
            itemBuilder: (context, index) => Stack(
              children: [
                CachedImage(imageUrl: state.likes.elementAt(index)),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<LikeBloc, LikesState>(
                              builder: (context, likeState) {
                            if (likeState is Likes) {
                              return LikeButton(
                                  onTap: (isLiked) async {
                                    _bloc.add(Dislike(
                                        id: state.likes.elementAt(index)));
                                    return !isLiked;
                                  },
                                  circleColor: CircleColor(
                                      start: Colors.red, end: Colors.red),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor: Colors.red,
                                    dotSecondaryColor: Colors.red,
                                  ),
                                  size: 32,
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color:
                                          isLiked ? Colors.white70 : Colors.red,
                                      size: 30,
                                    );
                                  });
                            } else {
                              return Text("Something went wrong...");
                            }
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text('Loading likes..');
        }
      },
    );
  }
}
