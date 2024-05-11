import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:netflix/common/util.dart';
import 'package:netflix/models/recommendation_model.dart';
import 'package:netflix/models/search_model.dart';
import 'package:netflix/screens/more_screen.dart';
import 'package:netflix/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<SearchModel> searchfuture;
  ApiServices apiservices = ApiServices();
  TextEditingController searchcontroller = TextEditingController();
  late Future<MovieReccomendationModel> popularmovie;
  SearchModel? searchmodel;

  void search(String query) {
    apiservices.getsearchedmoovie(query).then((results) => {
          setState(() {
            searchmodel = results;
          })
        });
  }

  @override
  void initState() {
    popularmovie = apiservices.getpopularmovies();
    super.initState();
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CupertinoSearchTextField(
                  controller: searchcontroller,
                  placeholder: 'search movie',
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    if (value.isEmpty) {
                    } else {
                      search(value);
                    }
                  },
                ),
              ),
              searchcontroller.text.isEmpty
                  ? FutureBuilder<MovieReccomendationModel>(
                      future: popularmovie,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data?.results;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Top Searches",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  // padding: const EdgeInsets.all(3),
                                  scrollDirection: Axis.vertical,
                                  itemCount: data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailScreen(
                                                movieId: data[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                '$imageUrl${data[index].posterPath}',
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                child: Text(
                                                  data[index].title,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ]);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : searchmodel == null
                      ? const SizedBox.shrink()
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchmodel?.results.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1.2 / 2,
                          ),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                searchmodel?.results[index].posterPath == null
                                    ? Image.asset('assets/logo.png')
                                    : Image.network(
                                        '$imageUrl${searchmodel!.results[index].posterPath}',
                                        height: 170,
                                      ),
                                Text(
                                  searchmodel!.results[index].title,
                                  style: TextStyle(fontSize: 10),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          })
            ],
          ),
        ),
      ),
    );
  }
}
