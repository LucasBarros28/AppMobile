import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lecternus/Config.dart';
import 'package:lecternus/main.dart';

class Pesquisar extends StatefulWidget {
  @override
  _PesquisarState createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  int _selectedIndex = 3;
  TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filterOptions = ['Perfil', 'Autores', 'Tags', 'Livros'];
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearch(String query) async {
    if (query.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    // Formato: "termo|filtro"
    String searchEntry =
        '${_searchController.text}|${_filterOptions[_selectedFilterIndex]}';

    // Remove duplicatas antes de adicionar
    _searchHistory.removeWhere((item) => item == searchEntry);

    // Adiciona no início da lista
    _searchHistory.insert(0, searchEntry);

    // Limita o histórico a 10 itens
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    await prefs.setStringList('searchHistory', _searchHistory);
    setState(() {});
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(initialIndex: index)),
      );
    }
  }

  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      print(
          "Pesquisando por: ${_searchController.text} em ${_filterOptions[_selectedFilterIndex]}");
      _saveSearch(_searchController.text);
    }
  }

  void _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    setState(() {
      _searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF57362B),
        automaticallyImplyLeading: false,
        title: Text(
          "Lecternus",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Config()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF57362B),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de pesquisa
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Pesquisar...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => _performSearch(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white70),
                    onPressed: _performSearch,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Filtros
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_filterOptions.length, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(
                          _filterOptions[index],
                          style: TextStyle(
                            color: _selectedFilterIndex == index
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(179, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: _selectedFilterIndex == index,
                        selectedColor: Color(0xFF57362B).withOpacity(0.8),
                        backgroundColor: Color(0xFF57362B).withOpacity(0.4),
                        side: BorderSide(
                          color: Colors.white70.withOpacity(0.3),
                          width: 1,
                        ),
                        showCheckmark: false,
                        onSelected: (selected) {
                          setState(() => _selectedFilterIndex = index);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Histórico de pesquisas
            if (_searchHistory.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Histórico de Pesquisas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _clearHistory,
                      child: Text(
                        'Limpar',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchHistory.length,
                  itemBuilder: (context, index) {
                    final parts = _searchHistory[index].split('|');
                    final query = parts[0];
                    final filter = parts.length > 1 ? parts[1] : '';

                    return Card(
                      color: Colors.white.withOpacity(0.1),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        leading: Icon(Icons.history, color: Colors.white70),
                        title: Text(
                          query,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Filtro: $filter',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          _searchController.text = query;
                          final filterIndex = _filterOptions.indexOf(filter);
                          if (filterIndex != -1) {
                            setState(() {
                              _selectedFilterIndex = filterIndex;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Text(
                    'Nenhum histórico de pesquisa',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
