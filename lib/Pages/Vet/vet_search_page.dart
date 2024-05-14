import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Model/PaginationDto.dart';
import 'package:vetadminconnectmobile/Model/Vet.dart';
import 'package:vetadminconnectmobile/Pages/Vet/vet_detail_page.dart';
import 'package:vetadminconnectmobile/Repository/vet_api/vet_http_api_repository.dart';

class VetSearchPage extends StatefulWidget {
  const VetSearchPage({super.key});

  @override
  State<VetSearchPage> createState() => _VetSearchPageState();
}

class _VetSearchPageState extends State<VetSearchPage> {
  var pagination = PaginationDto(null, 1, 100, '');
  var vetApi = VetHttpApiRepository();
  final _searchController = TextEditingController();
  List<Vet> _especialistas = [];
  List<Vet> _filteredEspecialistas = [];

  @override
  void initState() {
    super.initState();
    getVets();
    _searchController.addListener(() {
      _filterEspecialistas();
    });
  }
  void getVets()async{
    var response = await vetApi.getVets(pagination, '');
    if (response.wasSuccess) {
      setState(() {
        _especialistas = response.result!;
        _filteredEspecialistas = _especialistas;
      });
    }
  }
  void _filterEspecialistas() {
    final searchTerm = _searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      setState(() {
        _filteredEspecialistas = _especialistas;
      });
      return;
    }

    setState(() {
      _filteredEspecialistas = _especialistas.where((especialista) {
        final fullNameLower = especialista.fullName.toLowerCase();
        final cityNameLower = especialista.cityName.toLowerCase();
        final specialitiesLower = especialista.vetSpecialities.map((speciality) => speciality.name.toLowerCase()).toList();

        if (fullNameLower.contains(searchTerm) ||
            cityNameLower.contains(searchTerm)) {
          return true;
        }

        if (specialitiesLower.isNotEmpty) {
          for (final speciality in specialitiesLower) {
            if (speciality.contains(searchTerm)) {
              return true;
            }
          }
        }

        return false;
      }).toList();
    });
  }

  void _navigateToVeterinarioDetails(Vet veterinario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VeterinarioDetailsPage(veterinario: veterinario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Nombre, especialidad o ciudad...',
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: _filteredEspecialistas != null && _filteredEspecialistas!.isNotEmpty
      ? ListView.builder(
        itemCount: _filteredEspecialistas.length,
        itemBuilder: (context, index) {
          final veterinario = _filteredEspecialistas[index];
          var conse = Random().nextInt(100);
          veterinario.address = 'https://picsum.photos/200/30$conse';
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: Image.network(veterinario.address).image,
            ),
            title: Text(veterinario.fullName),
            subtitle: Text(veterinario.vetSpecialities.isEmpty ? veterinario.cityName : '${veterinario.vetSpecialities.first.name} - ${veterinario.cityName}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => _navigateToVeterinarioDetails(veterinario),
          );
        },
      ):
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
