import 'package:displaycharacters/data/models/character.dart';
import 'package:displaycharacters/data/services/characters_services.dart';

class CharactersRepository {
  final CharactersServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }
}
