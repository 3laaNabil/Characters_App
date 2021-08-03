import 'package:ch_app/business_logic/cubit/characters_cubit.dart';
import 'package:ch_app/data/models/characters.dart';
import 'package:ch_app/ui/widgets/cheracter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({key}) : super(key: key);

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> allcharacters = [];
  List<Character> searchedForCaracters = [];
  bool isSearch = false;
  final serachTextController = TextEditingController();

  Widget buildSearchField() {
    return TextField(
        controller: serachTextController,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: "find a character ....",
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        onChanged: (searchedForCaracters) {
          addSearchedItemToSearchedList(searchedForCaracters);
        });
  }

  void addSearchedItemToSearchedList(String searchedCaracters) {
    searchedForCaracters = allcharacters
        .where((character) =>
            character.name.toLowerCase().contains(searchedCaracters))
        .toList();
    setState(() {});
  }

  List<Widget> buildAppBarActions() {
    if (isSearch) {
      return [
        IconButton(
            onPressed: () {
              clearSearch();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            )),
      ];
    } else {
      return [
        IconButton(
            onPressed: () => startSearch(),
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ))
      ];
    }
  }

  void startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      isSearch = true;
    });
  }

  void _stopSearching() {
    clearSearch();

    setState(() {
      isSearch = false;
    });
  }

  void clearSearch() {
    setState(() {
      serachTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    allcharacters = BlocProvider.of<CharactersCubit>(context).getAllCh();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, State) {
      if (State is CharactersLoaded) {
        allcharacters = (State).characters;
        return buildLoadedWidget();
      } else {
        return showloadingIndicator();
      }
    });
  }

  Widget showloadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.purpleAccent.shade700,
      ),
    );
  }

  Widget buildLoadedWidget() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: serachTextController.text.isEmpty
          ? allcharacters.length
          : searchedForCaracters.length,
      itemBuilder: (context, index) => CharacterItem(
        character: serachTextController.text.isEmpty
            ? allcharacters[index]
            : searchedForCaracters[index],
      ),
    );
  }

  Widget buildAppBarTitle() {
    return Text(
      "characters",
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent.shade700,
          leading: isSearch
              ? BackButton(
                  color: Colors.white,
                )
              : Container(),
          title: isSearch ? buildSearchField() : buildAppBarTitle(),
          actions: buildAppBarActions(),
        ),
        body: buildBlocWidget());
  }
}
