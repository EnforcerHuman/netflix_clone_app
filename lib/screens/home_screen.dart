import 'package:flutter/material.dart';
import 'package:netflix/models/tv_series_model.dart';
import 'package:netflix/models/upcoming_model.dart';
import 'package:netflix/screens/search_screen.dart';
import 'package:http/http.dart' as http;
import 'package:netflix/services/api_services.dart';
import 'package:netflix/widgets/custom_carousel.dart';
import 'package:netflix/widgets/upcoming_movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UpcomingMovieModel> upcomingfuture;
  late Future<UpcomingMovieModel> nowplayingfuture;
  late Future<TvSeriesModel> tvseriesfuture;
  ApiServices apiservices = ApiServices();
  @override
  void initState() {
    super.initState();
    upcomingfuture = apiservices.getupcomingmovie();
    nowplayingfuture = apiservices.getNowPlayingMovies();
    tvseriesfuture = apiservices.gettvseries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.asset(
            'assets/logo.png',
            height: 50,
            width: 120,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                onTap: () {},
                child: Container(
                  color: Colors.blue,
                  height: 27,
                  width: 27,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            FutureBuilder<TvSeriesModel>(
                future: tvseriesfuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CustomCarouselSlider(data: snapshot.data!);
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
            SizedBox(
                height: 220,
                child: UpcomingMovieCard(
                    future: nowplayingfuture, headlineText: 'now playing')),
            SizedBox(
                height: 220,
                child: UpcomingMovieCard(
                    future: upcomingfuture, headlineText: 'Upcoming')),
          ]),
        ));
  }
}
