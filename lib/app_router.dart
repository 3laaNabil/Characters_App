import 'package:ch_app/data/Api/characters_api.dart';
import 'package:flutter/material.dart';

import 'package:ch_app/business_logic/cubit/characters_cubit.dart';
import 'package:ch_app/data/repository/characters_repository.dart';
import 'package:ch_app/ui/screens/characters_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/Strings.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(charactersApi: CharactersApi());

    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case all_Ch_route:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: CharactersScreen(),
          ),
        );
    }
  }
}
