import '/bloc/cat_like/bloc.dart';
import '/features/cats/detail_page.dart';
import '/cached/cached_network_images.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/cat_images/bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:like_button/like_button.dart';

class CatsScreen extends StatelessWidget {
  const CatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LikeBloc _likeBloc = BlocProvider.of<LikeBloc>(context);
    CatsBloc _catsBloc = BlocProvider.of<CatsBloc>(context);
    return BlocBuilder<CatsBloc, CatsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CatsLoaded) {
            return LazyLoadScrollView(
              onEndOfPage: () {
                _catsBloc.add(LoadNewImages());
              },
              child: GridView.builder(
                  padding: EdgeInsets.all(3),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.catsImages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return HeroScreen(
                            imgUrl: '${state.catsImages[index].url}',
                            tag: 'dash${state.catsImages[index].id}',
                          );
                        }));
                      },
                      child: Hero(
                        tag: 'dash${state.catsImages[index].id}',
                        flightShuttleBuilder: (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          return SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.all(30),
                              child: Image.network(
                                  '${state.catsImages[index].url}'),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            CachedImage(imageUrl: state.catsImages[index].url),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                              if (likeState.likes.contains(state
                                                  .catsImages[index].url)) {
                                                _likeBloc.add(Dislike(
                                                    id: state.catsImages[index]
                                                        .url));
                                                return true;
                                              } else {
                                                _likeBloc.add(Like(
                                                    id: state.catsImages[index]
                                                        .url));
                                                return false;
                                              }
                                            },
                                            size: 32,
                                            circleColor: CircleColor(
                                                start: Colors.red,
                                                end: Colors.red),
                                            bubblesColor: BubblesColor(
                                              dotPrimaryColor: Colors.red,
                                              dotSecondaryColor: Colors.red,
                                            ),
                                            likeBuilder: (_) {
                                              return Icon(
                                                CupertinoIcons.heart_fill,
                                                color: likeState.likes.contains(
                                                        state.catsImages[index]
                                                            .url)
                                                    ? Colors.red
                                                    : Colors.white70,
                                                size: 32,
                                              );
                                            },
                                          );
                                        } else {
                                          return Text(
                                              "Something went wrong...");
                                        }
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Center(
              child: SpinKitFadingCircle(
                size: 100,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.blue : Colors.blue[300],
                      borderRadius: BorderRadius.circular(180),
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
