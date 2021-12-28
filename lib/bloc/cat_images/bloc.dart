import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'event.dart';
part 'state.dart';

class CatsBloc extends Bloc<CatsEvent, CatsState> {
  final List<ImagesData> _images = [];
  CatsBloc() : super(CatsInitial());

  @override
  Stream<CatsState> mapEventToState(
    CatsEvent event,
  ) async* {
    if (event is InitialCats) {
      final catsImages = await loadImages();
      _images..addAll(catsImages);
      yield CatsLoaded(catsImages: _images);
    } else if (event is LoadNewImages) {
      final catsImages = await loadImages();
      _images..addAll(catsImages);
      yield CatsLoaded(catsImages: _images);
    }
  }
}

Future<http.Response> getData(String uri, Map<String, String> headers) async {
  return await http.get(Uri.parse(uri), headers: headers);
}

const CACHED_IMAGES = 'CACHED_IMAGES';

Future<List<ImagesData>> loadImages() async {
  final sharedPreference = await SharedPreferences.getInstance();
  try {
    var response = await getData(
        'https://api.thecatapi.com/v1/images/search?limit=20',
        {'x-api-key': 'd12e1ec7-64e0-4026-bfa0-f8336b070970'});

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<ImagesData> list = data.length > 0
          ? data
              .map((e) =>
                  ImagesData(url: e['url'].toString(), id: e['id'].toString()))
              .toList()
          : [];

      sharedPreference.setStringList(
          CACHED_IMAGES,
          data
              .map(
                (e) => json.encode({'url': e['url'], 'id': e['id']}),
              )
              .toList());

      return list;
    } else {
      return [];
    }
  } on SocketException {
    final cachedData = sharedPreference.getStringList(CACHED_IMAGES);
    if (cachedData == null) {
      return [];
    }

    return Future.value(cachedData.map((e) {
      final decodedImage = json.decode(e);
      return ImagesData(url: decodedImage['url'], id: decodedImage['id']);
    }).toList());
  } catch (error) {
    return [];
  }
}

class ImagesData {
  String url;
  String id;

  ImagesData({
    required this.url,
    required this.id,
  });
}
