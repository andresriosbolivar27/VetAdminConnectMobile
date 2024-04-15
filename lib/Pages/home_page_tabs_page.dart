import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Pages/profile_page.dart';

import 'pets_page.dart';


class HomePageTabsPage extends StatefulWidget {
  const HomePageTabsPage({super.key});

  @override
  State<HomePageTabsPage> createState() => _HomePageTabsPageState();
}

class _HomePageTabsPageState extends State<HomePageTabsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: [
                      //Tab(text: 'Mascotas', icon: Image.asset('assets/images/mislibros.png')),
                      const Tab(text: 'Mascotas', icon: Icon(Icons.pets_outlined, color: Colors.black)),
                      const Tab(text: 'Perfil', icon: Icon(Icons.person_2_outlined, color: Colors.black)),
                    ],
                  ),
                  title: const Text('Cliente'),
                ),
                body: const TabBarView(
                  children: [
                    PetsPage(),
                    ProfilePage(),
                    //BooksStorePage(),
                    //ProfilePage(),
                  ],
                )
            )
        )
    );
  }
}
