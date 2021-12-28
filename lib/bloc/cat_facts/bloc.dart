import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'event.dart';
part 'state.dart';

class CatFactsBloc extends Bloc<CatFactsEvent, CatFactsState> {
  CatFactsBloc() : super(CatFactsInitial());

  @override
  Stream<CatFactsState> mapEventToState(
    CatFactsEvent event,
  ) async* {
    if (event is FactsLoaded) {
      final facts = await loadFacts();
      yield CatsFactsLoaded(facts: facts);
    }
  }
}

Future<http.Response> getData(String uri, Map<String, String> headers) async {
  return await http.get(Uri.parse(uri));
}

Future<List<String>> loadFacts() async {
  var response = await getData('https://catfact.ninja/facts?limit=3', {});
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['data'];
    return data.length > 0
        ? data.map((i) => i['fact'].toString()).toList()
        : [];
  } else {
    return [];
  }
}
