import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Pages/Vet/vet_detail_page.dart';

class VetSearchPage extends StatefulWidget {
  const VetSearchPage({super.key});

  @override
  State<VetSearchPage> createState() => _VetSearchPageState();
}

class _VetSearchPageState extends State<VetSearchPage> {
  final _searchController = TextEditingController();
  List<Especialista> _especialistas = [
    Especialista(
      nombre: 'Dra. Sandra Zuñiga López',
      especialidad: 'Médico Cirujano',
      ubicacion: 'Medellín',
      imagen: 'https://picsum.photos/200/300',
    ),
    Especialista(
      nombre: 'Dr. Andrés Castaño Ríos',
      especialidad: 'Odontólogo',
      ubicacion: 'Bogotá',
      imagen: 'https://picsum.photos/200/301',
    ),
    Especialista(
      nombre: 'Dra. Paola Torres Pérez',
      especialidad: 'Nutricionista',
      ubicacion: 'Cali',
      imagen: 'https://picsum.photos/200/302',
    ),
  ];

  List<Especialista> _filteredEspecialistas = [];

  @override
  void initState() {
    super.initState();
    _filteredEspecialistas = _especialistas;
    _searchController.addListener(() {
      _filterEspecialistas();
    });
  }

  void _filterEspecialistas() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredEspecialistas = _especialistas.where((especialista) {
        return especialista.nombre.toLowerCase().contains(searchTerm) ||
            especialista.especialidad.toLowerCase().contains(searchTerm) ||
            especialista.ubicacion.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  void _navigateToVeterinarioDetails(Especialista veterinario) {
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
              backgroundImage: NetworkImage(veterinario.imagen),
            ),
            title: Text(veterinario.nombre),
            subtitle:
                Text(veterinario.especialidad + ' - ' + veterinario.ubicacion),
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
