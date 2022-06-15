
import 'package:flutter/material.dart';
import 'package:flutter_movie/widgets/widgets.dart';

import '../models/models.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //recibir argumento
    // todo: cambiar luego por una instancia de movie
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    // print(movie.title);

    return Scaffold(
      // es parecido a single scroll view
      // esta hecho para trabjar con slivers
      // los slivers son widgets que tienen cierto comportamient
      // preprogramado cuando se hace scroll en el contenido del padre

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _CustomAppBar(movie: movie),
          SliverList(
            delegate: SliverChildListDelegate([

              _PosterAndTitle(movie: movie),
              _OverviewScreen(movie: movie),
              _OverviewScreen(movie: movie),
              _OverviewScreen(movie: movie),
              CastingCards(movieId: movie.id),

            ])
          )
        ],
      ),

      // body: Container(
      //   child: Center(
      //     child: Text('$movie')
      //   )
      // ),
    );
  }
}


class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // es parecido al appbar pero se puede controlar el ancho y altura
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      // nunca desaparecer
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,

        // quitar el padding sobrante
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: Text(
            movie.title,
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(movie.fullPosterImg),
          fit: BoxFit.cover,
        ),
      ),


    );
  }

}



class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            // no necesariamente debe ser cliprrect
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                height: 150,
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
              ),
            ),
          ),

          const SizedBox(width: 20,),

          // tambien se podria arreglar con constraingBox
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.headline5,
          
                  // puede tener un titulo que pasa mas de la pantalla
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
          
                Text(
                  movie.originalTitle,
                  style: textTheme.subtitle1,
          
                  // puede tener un titulo que pasa mas de la pantalla
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
          
                Row(
                  children: [
                    const Icon(Icons.star_outline, size: 15, color: Colors.grey),
          
                    const SizedBox(width: 5,),
          
                    Text(
                      movie.voteAverage.toString(),
                      style: textTheme.caption,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
    
  }
}

class _OverviewScreen extends StatelessWidget {

  final Movie movie;

  const _OverviewScreen({super.key, required this.movie});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

}
