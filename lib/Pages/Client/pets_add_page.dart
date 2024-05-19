import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Enums.dart';
import 'package:vetadminconnectmobile/Model/Especie.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Pet.dart';
import 'package:vetadminconnectmobile/Model/Raza.dart';
import 'package:vetadminconnectmobile/Repository/breed_api/breed_http_api_repository.dart';
import 'package:vetadminconnectmobile/Repository/client_api/client_http_api_repository.dart';
import 'package:vetadminconnectmobile/Repository/specie_api/specie_http_api_repository.dart';

class AddPetPage extends StatefulWidget {
  final int _clientId;
  const AddPetPage(this._clientId, {super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _clientApi = ClientHttpApiRepository();
  final _speciesApi = SpecieHttpApiRepository();
  final _breedsApi = BreedHttpApiRepository();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late GenderType _selectedGender;
  late Especie? _selectedSpecie = null;
  late Raza? _selectedBreed = null;
  late SizeType _selectedSize;
  File? _imageFile;
  String? _profileImageBase64;
  get clientId => this.clientId;
  List<Especie> especies = [];
  List<Especie> especiesFilter = [];
  List<Raza> razas = [];
  List<Raza> razasFilter = [];

  Future<void> _loadData() async {
    // Fetch species and breeds data
    final fetchedEspecies = await _fetchEspecies();
    setState(() {
      if(fetchedEspecies.wasSuccess){
        especies = fetchedEspecies.result!;
      }
    });
  }

  Future<ApiResponse<List<Especie>>> _fetchEspecies() async {
    return await _speciesApi.getCombo();
  }

  Future<ApiResponse<List<Raza>>> _fetchRazas (int specieId)  async {
    return await _breedsApi.getCombo(specieId,'');
  }

  Future<void> _fetchRazasForSpecie(int specieId) async{
    razasFilter.clear();
    _selectedBreed = null;
    var breedResult =  await _breedsApi.getCombo(specieId, '');

    if(breedResult.wasSuccess){
      setState(() {
        razasFilter = breedResult.result!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _selectedGender = GenderType.male;
    _selectedSize = SizeType.small;
    _selectedBreed = null;
    if(especies.isEmpty){
      _loadData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Mascota'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  _imageFile != null ? FileImage(_imageFile!) : null,
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  _showImagePicker(context);
                },
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la mascota',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Edad de la mascota',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<GenderType>(
              value: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              items: GenderType.values.map((size) {
                return DropdownMenuItem<GenderType>(
                  value: size,
                  child: Text(genderTypeTranslations[size]!),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Género',
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<Especie>(
              value: _selectedSpecie,
              hint: const Text('Seleccione una Especie'),
              items: especies.map((especie) {
                return DropdownMenuItem(
                  value: especie,
                  child: Text(especie.name),
                );
              }).toList(),
              onChanged: (especie) {
                setState(() {
                  _selectedSpecie = especie;
                  if(especie != null){
                    _fetchRazasForSpecie(especie.id);
                  }
                });
              },
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<Raza>(
              value: _selectedBreed,
              hint: const Text('Seleccione una Raza'),
              items: razasFilter.map((raza) {
                return DropdownMenuItem<Raza>(
                  value: raza,
                  child: Text(raza.name),
                );
              }).toList(),
              onChanged: (selectedRaza) {
                setState(() {
                  _selectedBreed = selectedRaza!;
                });
              },
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<SizeType>(
              value: _selectedSize,
              onChanged: (newValue) {
                setState(() {
                  _selectedSize = newValue!;
                });
              },
              items: SizeType.values.map((size) {
                return DropdownMenuItem<SizeType>(
                  value: size,
                  child: Text(sizeTypeTranslations[size]!),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Tamaño',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await _addPet();
              },
              child: const Text('Agregar Mascota'),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Tomar foto'),
                onTap: () async {
                  Navigator.pop(context,
                      await _picker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Seleccionar de galería'),
                onTap: () async {
                  Navigator.pop(context,
                      await _picker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    if (image != null) {
      final File file = File(image.path);
      setState(() {
        _imageFile = file;
        _profileImageBase64 = base64Encode(file.readAsBytesSync());
      });
    }
  }

  Future<void> _addPet() async {
    final String petName = _nameController.text;
    final int petAge =
        _ageController.text.isNotEmpty ? int.parse(_ageController.text) : 0;
    final GenderType petGenderType = _selectedGender;
    final int petSpecieId = _selectedSpecie!.id;
    final int petBreedId = _selectedBreed!.id;
    String? petImage;
    final SizeType petSize = _selectedSize;

    if(_imageFile != null){
      petImage = base64Encode(_imageFile!.readAsBytesSync());
    }

    List<Pet> pets = [
      Pet(
        id: 0,
        clientId: widget._clientId ,
        name: petName,
        age: petAge,
        genderType: petGenderType.index,
        specieId: petSpecieId,
        breedId: petBreedId,
        photo: petImage,
        sizeType: petSize.index,
      )
    ];

    Client client = Client(
      '',
      '',
      '',
      '',
      '',
      null,
      0,
      0,
      '',
      '',
      '',
      '',
      '',
      '',
      widget._clientId,
      pets,
    );

    var result = await _clientApi.addPets(client, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW52ZXRAeW9wbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsIkRvY3VtZW50IjoiMTAxMCIsIkZpcnN0TmFtZSI6IkFkbWluIiwiTGFzdE5hbWUiOiJWZXRBZG1pbkNvbm5lY3QiLCJBZGRyZXNzIjoiQ2FsbGUgMjQiLCJQaG90byI6IiIsIkNpdHlJZCI6IjEiLCJVc2VySWQiOiIxOTI3MDgxZS1jMWFlLTRiYTctODAzZS0zNzY5MDE3NWNlNzEiLCJleHAiOjE3MTg2ODAwMzV9.jeiGN3aWjb-232MB2nsBQaFfzvq6ZU_QISfgJCeNnXY') ;

    if(result.wasSuccess){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mascota registrada'),
        ),
      );
      Navigator.pop(context);
    }

    if(!result.wasSuccess){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar mascota'),
        ),
      );
    }
  }
}
