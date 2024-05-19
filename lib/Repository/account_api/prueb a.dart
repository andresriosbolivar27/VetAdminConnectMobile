import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Model/Especie.dart';
import 'package:vetadminconnectmobile/Model/Raza.dart';

class MyDropDownPage extends StatefulWidget {
  @override
  _MyDropDownPageState createState() => _MyDropDownPageState();
}

class _MyDropDownPageState extends State<MyDropDownPage> {
  // Initial data for species and breeds (empty)
  List<Especie> especies = [];
  List<Raza> razas = [];

  // Currently selected specie
  Especie? selectedEspecie;

  @override
  void initState() {
    super.initState();
    // Load data when the page loads
    _loadData();
  }

  Future<void> _loadData() async {
    // Fetch species and breeds data
    final fetchedEspecies = await _fetchEspecies();
    final fetchedRazas = await _fetchRazas();

    setState(() {
      especies = fetchedEspecies;
      razas = fetchedRazas;
    });
  }

  Future<List<Especie>> _fetchEspecies() async {
    // Replace with your actual data fetching logic
    // (e.g., API call, local database access)
    await Future.delayed(Duration(seconds: 2)); // Simulate fetching data

    return [
      Especie(id: 1, name: 'Perro', description: '', breedsNumber: 0),
      Especie(id: 2, name: 'Gato', description: '', breedsNumber: 0),
    ];
  }

  Future<List<Raza>> _fetchRazas() async {
    // Replace with your actual data fetching logic
    // (e.g., API call, local database access)
    await Future.delayed(Duration(seconds: 2)); // Simulate fetching data

    return [
      Raza(id: 1, name: 'Pastor Alemán', specieId: 1),
      Raza(id: 2, name: 'Labrador Retriever', specieId: 1),
      Raza(id: 3, name: 'Siamés', specieId: 2),
      Raza(id: 4, name: 'Persa', specieId: 2),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Menus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Especie>(
              value: selectedEspecie,
              hint: Text('Seleccione una Especie'),
              items: especies.map((especie) => DropdownMenuItem(
                value: especie,
                child: Text(especie.name),
              )).toList(),
              onChanged: (especie) {
                setState(() {
                  selectedEspecie = especie;
                  razas = razas.where((raza) => raza.specieId == especie?.id).toList();
                });
              },
            ),
            DropdownButtonFormField<Raza>(
              value: razas.isNotEmpty ? razas.first : null,
              hint: Text('Seleccione una Raza'),
              items: razas.isEmpty
                  ? [DropdownMenuItem(child: Text('No hay Razas disponibles'))]
                  : razas.map((raza) => DropdownMenuItem(
                value: raza,
                child: Text(raza.name),
              )).toList(),
              onChanged: selectedEspecie != null ? (raza) => setState(() => razas = [raza!]) : null,
            ),
          ],
        ),
      ),
    );
  }
}
