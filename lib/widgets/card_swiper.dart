
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> movies;
   
  const CardSwiper({Key? key, required this.movies}) : super(key: key);
  
  @override
  // context conoce todo el arbol anterior
  // menos las que se crea aquí
  Widget build(BuildContext context) {

    // se va a colocar el 50% de la pantalla
    final size = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      // todo lo ancho
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (context, index) {

          final movie = movies[index];
          movie.heroId = 'swiper${movie.id}';
          // print(movie.fullPosterImg);

          // animacion de entrada
          return GestureDetector(
            // tap a la imagen
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            // permite el border radius
            child: Hero(
              // animacion de transicion
              // deben ser unico
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  // adaptar la imange al tamaño del contenedor padre
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
