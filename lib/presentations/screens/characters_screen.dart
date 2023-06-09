import 'package:displaycharacters/cubit/characters_cubit.dart';
import 'package:displaycharacters/data/models/character.dart';
import 'package:displaycharacters/presentations/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
// import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedForCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: Colors.grey,
      decoration: const InputDecoration(
        hintText: 'Find a character...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
      onChanged: (searchedCharacter) {
        addSearchedFOrItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedFOrItemsToSearchedList(String searchedCharacter) {
    searchedForCharacters = allCharacters
        .where((character) =>
            character.name!.toLowerCase().startsWith(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(
            Icons.search,
          ),
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  AppBar _appBar({bool isNotConnected = false}) {
    return AppBar(
      backgroundColor: Colors.purple.shade300,
      leading: _isSearching
          ? const BackButton(
              color: Colors.white,
            )
          : const SizedBox.shrink(),
      title: _isSearching && !isNotConnected
          ? _buildSearchField()
          : const Text('Characters'),
      actions: !isNotConnected ? _buildAppBarActions() : [],
    );
  }

  Widget buildLoadedListWidgets() {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: [
              buildCharactersList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchTextController.text.isEmpty
          ? allCharacters.length
          : searchedForCharacters.length,
      itemBuilder: (ctx, index) {
        return CharacterItem(
          character: _searchTextController.text.isEmpty
              ? allCharacters[index]
              : searchedForCharacters[index],
        );
      },
    );
  }

  Widget buildNoInternetWidget() {
    return Scaffold(
      appBar: _appBar(isNotConnected: true),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Can\'t connect .. check internet',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Image.asset('assets/images/no_internet.png')
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          print(connected);

          if (connected) {
            return BlocBuilder<CharactersCubit, CharactersState>(
              builder: (context, state) {
                if (state is CharactersLoaded) {
                  allCharacters = (state).characters;
                  return buildLoadedListWidgets();
                } else {
                  return Scaffold(
                    appBar: _appBar(isNotConnected: true),
                    body: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple,
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return buildNoInternetWidget();
          }
        },
        child: Scaffold(
          appBar: _appBar(isNotConnected: true),
          body: const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}
