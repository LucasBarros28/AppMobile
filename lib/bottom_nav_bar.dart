import 'package:flutter/material.dart';
import "package:lecternus/Profile.dart";
import 'package:lecternus/criarReview.dart';
import 'package:lecternus/SignIn.dart';


class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFCDA68C),
      selectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Pesquisa",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box,
            size: 50.0,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
          ),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Perfil",
        ),
      ],
    );
  }
}
