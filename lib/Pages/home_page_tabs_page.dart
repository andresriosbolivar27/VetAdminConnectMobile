import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Pages/Vet/vet_search_page.dart';
import 'package:vetadminconnectmobile/Pages/profile_page.dart';

import 'Client/pets_page.dart';


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
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Mascotas', icon: Icon(Icons.pets_outlined, color: Colors.black),),
                      Tab(text: 'Veterinarios', icon: Icon(Icons.medical_services_outlined, color: Colors.black)),
                      Tab(text: 'Perfil', icon: Icon(Icons.person_2_outlined, color: Colors.black)),
                    ],
                    indicatorColor: Colors.blueAccent,
                    labelColor: Colors.blueAccent,
                  ),
                  title: const Text('Cliente'),
                ),
                body: const TabBarView(
                  children: [
                    PetsPage(),
                    VetSearchPage(),
                    UserProfilePage(),
                  ],
                )
            )
        )
    );
  }
}
