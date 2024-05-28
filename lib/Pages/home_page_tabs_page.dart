import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/User.dart';
import 'package:vetadminconnectmobile/Pages/Vet/vet_reviews_page.dart';
import 'package:vetadminconnectmobile/Pages/Vet/vet_search_page.dart';
import 'package:vetadminconnectmobile/Pages/profile_page.dart';
import 'package:vetadminconnectmobile/Services/TokenService.dart';
import 'Client/pets_page.dart';

class HomePageTabsPage extends StatefulWidget {
  const HomePageTabsPage({super.key});

  @override
  State<HomePageTabsPage> createState() => _HomePageTabsPageState();
}

class _HomePageTabsPageState extends State<HomePageTabsPage> {
  final TokenService _tokenService = TokenService();
  String userRole = 'Client';


  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  void _getUserRole() async {
    var role = await _tokenService.getTokenData('decodedToken');
    setState(() {
      userRole = role['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] as String;
      role.clear();
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildHomePage(),
    );
  }

  Widget _buildHomePage() {
    late Widget homePage;
    if(userRole == 'Client'){
      homePage = _buildClienteTabs();
    }
    if(userRole == 'Vet'){
      homePage = _buildVeterinarioTabs();
    }

    return homePage;
  }

  Widget _buildClienteTabs() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mascotas', icon: Icon(Icons.pets_outlined, color: Colors.black)),
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
        ),
      ),
    );
  }

  Widget _buildVeterinarioTabs() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Contactos', icon: Icon(Icons.contacts_outlined, color: Colors.black)),
              Tab(text: 'Perfil', icon: Icon(Icons.person_2_outlined, color: Colors.black)),
            ],
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
          ),
          title: const Text('Veterinario'),
        ),
        body: const TabBarView(
          children: [
            VetReviewsPage(),
            UserProfilePage(),
          ],
        ),
      ),
    );
  }
}
