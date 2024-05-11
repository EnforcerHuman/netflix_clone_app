import 'dart:convert';
import 'dart:developer';

import 'package:netflix/common/util.dart';
import 'package:netflix/models/movie_detail_model.dart';
import 'package:netflix/models/movie_reccomendation_model.dart';
import 'package:netflix/models/recommendation_model.dart';
import 'package:netflix/models/search_model.dart';
import 'package:netflix/models/tv_series_model.dart';
import 'package:netflix/models/upcoming_model.dart';
import 'package:http/http.dart' as http;

const baseurl = 'https://api.themoviedb.org/3/';
var key = '?api_key=$apikey';
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getupcomingmovie() async {
    endPoint = 'movie/upcoming';
    final url = '$baseurl$endPoint$key';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('error occured');
    }
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endPoint = 'movie/upcoming';
    final url = '$baseurl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<TvSeriesModel> gettvseries() async {
    endPoint = 'tv/top_rated';
    final url = '$baseurl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<SearchModel> getsearchedmoovie(String moviename) async {
    endPoint = 'search/movie?query=$moviename';
    final url = '$baseurl$endPoint';
    print(url);
    final uri = Uri.parse(url);
    print('uri is : $uri');
    final response = await http.get((uri), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxODM0YTc2NjRlMTc1NGIzYmM5MTgxOTZmOTc5YWNkNyIsInN1YiI6IjY2M2QwOGQwNjkwMGY5MTVjMjFlZjdhMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.xAMgK9E6RiPE7-f01EWEQUYKqhvyneoG3bDZVunDFZk'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return SearchModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('unable tp find searched movie');
    }
  }

  Future<MovieReccomendationModel> getpopularmovies() async {
    const endpoint = 'movie/popular';
    final url = '$baseurl$endpoint$key';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return MovieReccomendationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('unable to load popular movie');
    }
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    endPoint = 'movie/$movieId';
    final url = '$baseurl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  Future<MovieRecommendationsModel> getMovieRecommendations(int movieId) async {
    endPoint = 'movie/$movieId/recommendations';
    final url = '$baseurl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }
}
