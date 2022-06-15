
import 'package:flutter/material.dart';
import 'package:flutter_movie/providers/movies_provider.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';

void main() => runApp(const AppState());


class AppState extends StatelessWidget {

  const AppState({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // 
    return MultiProvider(
      providers: [

        // se debe exteder para arreglar error en movies provider
        // pordefecto manera perezoza
        // crea el provider si se necesita
        ChangeNotifierProvider(
          // toda la app debe saber este provider
          // entonces dejar a lo alto del arbol de widgets
          create: (_) => MoviesProvider(),

          // media vez creado llama movies provider
          lazy: false,
          
        ),

      ],

      // se debe agrear app
      child: const MyApp(),

    );
  }

}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas app',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'details': (_) => const DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.indigo
        )
      ),
    );
  }
}
