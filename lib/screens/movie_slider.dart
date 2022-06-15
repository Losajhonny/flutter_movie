
import 'package:flutter/material.dart';

import '../models/models.dart';

/**
 * pensar los mas reutilizable posible
 * porque se podra utilizar en otro lado
 * 
 * 
 * ref a scrollview
 * ideal converter statefull
 * destruir cuando no se necesita
 * 
 * */

class MovieSlider extends StatefulWidget {
  final String? title;
  final List<Movie> movies;

  final Function onNextPage;
  
  const MovieSlider({
    Key? key,
    this.title,
    required this.movies,
    required this.onNextPage
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  //valores del slider
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      // debeestar ammarado al widget que use scroll
      // cuando este cerca del final
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            // se puede agregar padding al container
            // pero no quedará bien
            // porque no desaperecerá las imagenes
            // fuera de la pantalla sino que adentro
            // del container
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Text(
                widget.title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )
              ),
            ),

          const SizedBox(height: 5,),

          // su tamaño es la del padre
          // eso genera un error porque
          // su padre es flexible
          // se resuelve con expanded
          // ofrece el tamaño que queda disponible

          Expanded(
            child: ListView.builder(
              // asociar scroll
              controller: scrollController,

              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) => _MoviePoster(movie: widget.movies[index], heroId: '${ widget.title }-$index-${widget.movies[index].id}'),
            ),
          )

        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie movie;
  final String heroId;

  const _MoviePoster({Key? key, required this.movie, required this.heroId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      // color: Colors.green,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: [

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              // si existe que debo hacer
              tag: movie.heroId!,
              child: ClipRRect(
                // para colocar border
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  // image: NetworkImage('https://mario.wiki.gallery/images/thumb/8/81/MKT_Icon_Bowser%27s_Shell.png/1200px-MKT_Icon_Bowser%27s_Shell.png'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 5,),

          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }
}
