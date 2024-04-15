import 'package:flutter/material.dart';

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
                      Tab(icon: Image.asset('assets/images/mislibros.png')),
                      //Tab(icon: Image.asset('assets/images/bookapi.png')),
                      //Tab(icon: Image.asset('assets/images/bookstore.png')),
                      const Tab(icon: Icon(Icons.person_2_outlined, color: Colors.black)),
                    ],
                  ),
                  title: const Text('Mis Records'),
                ),
                body: const TabBarView(
                  children: [
                    PetsPage(),
                    //BooksApiPage(),
                    //BooksStorePage(),
                    //ProfilePage(),
                  ],
                )
            )
        )
    );
  }
}
