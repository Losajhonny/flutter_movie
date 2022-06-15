
// proveedor de información


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_movie/helpers/debouncer.dart';
import 'package:flutter_movie/models/now_playing_response.dart';
import 'package:flutter_movie/models/search_response.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {

  final String _apiKey = 'fd10e091943611a036faafc77c8e00d2';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),

  );
  final StreamController<List<Movie>> _suggestionScreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionScreamController.stream;

  MoviesProvider() {
    // print('moies provider ini');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {

    final jsonData = await _getJsonData('3/movie/now_playing');
    
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    
    // todos los widgets
    // redibujar widgets
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    
    final popularResponse = PopularResponse.fromJson(jsonData);

    // agregar
    popularMovies = [ ...popularMovies , ...popularResponse.results];

    // print(popularMovies[0]);
    
    // todos los widgets
    // redibujar widgets
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    // print('req info server - cast');
    
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    if (query == '') return [];

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {

      // print('get value: $value');
      final results = await searchMovie(value);

      // se debe emitir valor
      _suggestionScreamController.add(results);

    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
