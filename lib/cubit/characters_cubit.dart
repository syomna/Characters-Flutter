import 'package:bloc/bloc.dart';
import 'package:displaycharacters/data/models/character.dart';
import 'package:displaycharacters/data/repository/characters_repository.dart';
import 'package:flutter/material.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character> characters = [];

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    }).catchError((e) => print(e));

    return characters;
  }
}
