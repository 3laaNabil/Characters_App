import 'package:bloc/bloc.dart' show Cubit;
import 'package:ch_app/data/models/characters.dart';
import 'package:ch_app/data/repository/characters_repository.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;

  List<Character> characters = [];

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> getAllCh() {
    charactersRepository.getAllCh().then((characters) {
      emit(CharactersLoaded(characters: characters));
      this.characters = characters;
    });

    return characters;
  }
}
