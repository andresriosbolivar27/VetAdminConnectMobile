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
  var pagination = PaginationDto(null, 1, 10, '');
  var vetApi = VetHttpApiRepository();
  final _searchController = TextEditingController();
  List<Vet> _especialistas = [];
  // List<Especialista> _especialistas = [
  //   Especialista(
  //     nombre: 'Dra. Sandra Zuñiga López',
  //     especialidad: 'Médico Cirujano',
  //     ubicacion: 'Medellín',
  //     imagen: 'https://picsum.photos/200/300',
  //   ),
  //   Especialista(
  //     nombre: 'Dr. Andrés Castaño Ríos',
  //     especialidad: 'Odontólogo',
  //     ubicacion: 'Bogotá',
  //     imagen: 'https://picsum.photos/200/301',
  //   ),
  //   Especialista(
  //     nombre: 'Dra. Paola Torres Pérez',
  //     especialidad: 'Nutricionista',
  //     ubicacion: 'Cali',
  //     imagen: 'https://picsum.photos/200/302',
  //   ),
  // ];

  List<Vet> _filteredEspecialistas = [];

  @override
  void initState() {
    super.initState();
    getVets();
    //_filteredEspecialistas = _especialistas;
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
  void _filterEspecialistas() async {

    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredEspecialistas = _especialistas.where((especialista) {
        return
          especialista.fullName.toLowerCase().contains(searchTerm) ||
              especialista.vetSpecialities.first.name.toLowerCase().contains(searchTerm) ||
              especialista.cityId.toString().toLowerCase().contains(searchTerm);
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
          decoration: InputDecoration(
            hintText: 'Buscar especialista...',
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredEspecialistas.length,
        itemBuilder: (context, index) {
          final veterinario = _filteredEspecialistas[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/200/302'),
            ),
            title: Text(veterinario.fullName),
            subtitle:
            Text(veterinario.vetSpecialities.first.name + ' - ' + veterinario.cityId.toString()),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => _navigateToVeterinarioDetails(veterinario),
          );
        },
      ),
    );
  }
}

class Especialista {
  String nombre;
  String especialidad;
  String ubicacion;
  String imagen;

  Especialista({
    required this.nombre,
    required this.especialidad,
    required this.ubicacion,
    required this.imagen,
  });
}
