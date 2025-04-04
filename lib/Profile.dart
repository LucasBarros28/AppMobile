import 'package:flutter/material.dart';
import 'Config.dart';
import 'Sobre.dart';
import 'bottom_nav_bar.dart';
import 'Home.dart';
import 'main.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3; // Define o índice da aba "Perfil"

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(initialIndex: index)),
      );
    }
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
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.webp'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alex Marques",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text("0",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text("Reviews",
                              style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              Text("0",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text("Leitores",
                              style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              Text("0",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text("Seguindo",
                              style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur bibendum justo purus, nec pellentesque arcu posuere suscipit.",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
      /* bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),*/
    );
  }
}
