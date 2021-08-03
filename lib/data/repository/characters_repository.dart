import 'package:ch_app/data/Api/characters_api.dart';
import 'package:ch_app/data/models/characters.dart';

class CharactersRepository {
  final CharactersApi charactersApi;
  CharactersRepository({
    required this.charactersApi,
  });

  Future<List<Character>> getAllCh() async {
    final character = await charactersApi.getAllCh();

    return character.map((character) => Character.fromJson(character)).toList();
  }
}
