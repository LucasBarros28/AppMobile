import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lecternus/Config.dart';
import 'package:lecternus/main.dart';
import 'package:lecternus/database_helper.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/Review.dart';
import 'package:lecternus/UserProfilePage.dart';
import 'package:lecternus/SignIn.dart';
import 'dart:typed_data';


class Pesquisar extends StatefulWidget {
  @override
  _PesquisarState createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  int _selectedIndex = 3;
  TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filterOptions = ['Usuário', 'Review'];
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _performSearch(_searchController.text);
    });
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(initialIndex: index)),
      );
    }
  }

  Future<void> _performSearch(String input) async {
    final db = await DatabaseHelper().db;
    final query = input.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }

    if (_selectedFilterIndex == 0) {
      // Buscar perfis por @tag
      final result = await db.query(
        'Profile',
        where: 'LOWER(tag) LIKE ?',
        whereArgs: ['%$query%'],
      );

      setState(() {
        _searchResults = result.map((p) => {
          'type': 'user',
          'id_profile': p['id_profile'],
          'tag': p['tag']
        }).toList();
      });
    } else if (_selectedFilterIndex == 1) {
      // Buscar reviews
      final result = await db.rawQuery('''
        SELECT r.*, p.tag
        FROM Review r
        JOIN Profile p ON r.id_profile = p.id_profile
        WHERE LOWER(r.title_review) LIKE ? OR LOWER(r.title_book) LIKE ?
      ''', ['%$query%', '%$query%']);

      setState(() {
        _searchResults = result.map((r) => {
          'type': 'review',
          'review': ReviewModel(
            id: r['id_review'] as int,
            profileId: r['id_profile'] as int,
            userName: r['tag'] as String,
            reviewTitle: r['title_review'] as String,
            bookTitle: r['title_book'] as String,
            reviewText: r['content'] as String,
            bookAuthor: r['author_book'] as String,
            imageBlob: r['image_blob'] as Uint8List,
          )
        }).toList();
      });
    }
  }

  Widget _buildFilters() {
    return Row(
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
            selectedColor: Color(0xFFCDA68C),
            backgroundColor: Color(0xFF57362B).withOpacity(0.4),
            side: BorderSide(color: Colors.white70.withOpacity(0.3), width: 1),
            showCheckmark: false,
            onSelected: (selected) {
              setState(() => _selectedFilterIndex = index);
              _performSearch(_searchController.text);
            },
          ),
        );
      }),
    );
  }

  Widget _buildResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text("Nenhum resultado encontrado", style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];

        if (item['type'] == 'user') {
          return Card(
            color: Color(0xFFCDA68C),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(
                      idProfile: item['id_profile'] as int,
                      tag: item['tag'] as String,
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundColor: Color(0xFF57362B),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text('@${item['tag']}', style: TextStyle(color: Color(0xFF57362B))),
              subtitle: Text('Perfil de usuário', style: TextStyle(color: Color(0xFF57362B))),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF57362B)),
            ),
          );
        } else {
          final ReviewModel review = item['review'];
          return Card(
            color: Color(0xFFCDA68C),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewPage(review: review)),
                );
              },
              contentPadding: EdgeInsets.all(12),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('@${review.userName}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF57362B))),
                  SizedBox(height: 4),
                  Text(review.reviewTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF57362B))),
                  SizedBox(height: 2),
                  Text('Livro: ${review.bookTitle}', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF57362B))),
                  SizedBox(height: 8),
                  Text(
                    review.reviewText.length > 100
                        ? '${review.reviewText.substring(0, 100)}...'
                        : review.reviewText,
                    style: TextStyle(fontSize: 13, color: Color(0xFF57362B)),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF57362B),
        automaticallyImplyLeading: false,
        title: Text("Lecternus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Config()));
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF57362B),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchResults.clear());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildFilters(),
            SizedBox(height: 20),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }
}
