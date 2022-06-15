
import 'package:flutter/material.dart';
import 'package:flutter_movie/screens/screens.dart';
import 'package:flutter_movie/search/search_delegate.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // magia del provider
    // ve al arbol de widgets y trae la instancia de movies provider
    final moviesProvider = Provider.of<MoviesProvider>(context,
    // redibujate
    listen: true);

    // print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Peliculas en cines',
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate()
              );
            },
            icon: const Icon(Icons.search)
          ),
        ],
      ),
      body: SingleChildScrollView(
        // permite hacer scroll en la pantalla
        child: Column(
          children: [
            // todos cardSwiper
      
            // tarjetas principales
            CardSwiper(movies: moviesProvider.onDisplayMovies),
      
            // slider de peliculas
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares', // opcional
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
      
          ],
        ),
      )
    );
  }
}
