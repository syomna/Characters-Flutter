import 'package:displaycharacters/constants/constants.dart';
import 'package:displaycharacters/cubit/characters_cubit.dart';
import 'package:displaycharacters/data/models/character.dart';
import 'package:displaycharacters/data/repository/characters_repository.dart';
import 'package:displaycharacters/data/services/characters_services.dart';
import 'package:displaycharacters/presentations/screens/characters_details_screens.dart';
import 'package:displaycharacters/presentations/screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharactersServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext contxt) => charactersCubit,
            child: CharactersScreen(),
          ),
        );

      case characterDetailsScreen:
        final character = settings.arguments as Character;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                CharactersCubit(charactersRepository),
            child: CharacterDetailsScreen(
              character: character,
            ),
          ),
        );
    }
  }
}
