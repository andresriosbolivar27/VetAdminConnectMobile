import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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

class EditPetPage extends StatefulWidget {
  final Pet pet;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EditPetPage({required this.pet, Key? key}) : super(key: key);

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
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
    final fetchedEspecies = await _fetchEspecies();
    if (fetchedEspecies.wasSuccess) {
      setState(() {
        especies = fetchedEspecies.result!;
        _selectedSpecie =
            especies.firstWhere((e) => e.id == widget.pet.specieId);
      });
    }
  }

  Future<ApiResponse<List<Especie>>> _fetchEspecies() async {
    return await _speciesApi.getCombo();
  }

  Future<ApiResponse<List<Raza>>> _fetchRazas(int specieId) async {
    return await _breedsApi.getCombo(specieId, '');
  }

  Future<void> _fetchRazasForSpecie(int specieId) async {
    razasFilter.clear();
    _selectedBreed = null;
    var breedResult = await _breedsApi.getCombo(specieId, '');

    if (breedResult.wasSuccess) {
      setState(() {
        razasFilter = breedResult.result!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _ageController = TextEditingController(text: widget.pet.age.toString());
    _selectedGender = GenderType.values[widget.pet.genderType];
    _selectedSize = SizeType.values[widget.pet.sizeType];
    if(widget.pet.photo != null && widget.pet.photo!.isNotEmpty){
      _imageFile = File(widget.pet.photo!);
    }

    _loadData();
    _loadData2();
  }

  Future<void> _loadData2() async {
    final fetchedBreeds = await _fetchRazas(widget.pet.specieId);
    if (fetchedBreeds.wasSuccess) {
      setState(() {
        razas = fetchedBreeds.result!;
        _selectedBreed = razas.firstWhere((e) => e.id == widget.pet.breedId);
      });
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
        title: const Text('Actualizar Mascota'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: widget._formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null && _imageFile!.path.isNotEmpty ? NetworkImage(_imageFile!.path) : null,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    _showImagePicker(context);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la mascota',
                  helperText: 'Campo obligatorio',
                ),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    validatePetName(_nameController.text.trim())!
                        ? null
                        : 'Debe ingresar el nombre de la mascota',
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Edad de la mascota',
                  helperText: 'Campo obligatorio',
                ),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => validatePetAge(_ageController.text.trim())
                    ? null
                    : 'Debe ingresar la edad de la mascota',
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => validatePetSpecie()!
                    ? null
                    : 'Debe Seleccionar la especie de la mascota',
                items: especies.map((especie) {
                  return DropdownMenuItem(
                    value: especie,
                    child: Text(especie.name),
                  );
                }).toList(),
                onChanged: (especie) {
                  setState(() {
                    _selectedSpecie = especie;
                    if (especie != null) {
                      _fetchRazasForSpecie(especie.id);
                    }
                  });
                },
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<Raza>(
                value: _selectedBreed,
                hint: const Text('Seleccione una Raza'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => validatePetBreed()!
                    ? null
                    : 'Debe Seleccionar la raza de la mascota',
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
                  if (widget._formKey.currentState!.validate()) {
                    await _editPet();
                  }
                },
                child: const Text('Actualizar Mascota'),
              ),
            ],
          ),
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

  Future<void> _editPet() async {
    final String petName = _nameController.text;
    final int petAge =
        _ageController.text.isNotEmpty ? int.parse(_ageController.text) : 0;
    final GenderType petGenderType = _selectedGender;
    final int petSpecieId = _selectedSpecie!.id;
    final int petBreedId = _selectedBreed!.id;
    final SizeType petSize = _selectedSize;
    String? petImage;

    if (_imageFile != null) {
      petImage = base64Encode(_imageFile!.readAsBytesSync());
    }

    // Aquí necesitarías enviar una solicitud para editar la mascota con los nuevos datos
    // Podrías usar la misma lógica que en _addPet para enviar la solicitud al servidor

    // Por ahora, simplemente imprimimos los datos para verificar
    print('Nombre de la mascota: $petName');
    print('Edad de la mascota: $petAge');
    print('Género: ${petGenderType.toString()}');
    print('Especie: ${_selectedSpecie!.name}');
    print('Raza: ${_selectedBreed!.name}');
    print('Tamaño: ${petSize.toString()}');
    print('Imagen: $petImage');

    // Si se realiza con éxito, puedes cerrar la página
    Navigator.pop(context);
  }

  bool? validatePetName(String? value) {
    if (value!.isEmpty == true) {
      return false;
    }
    return true;
  }

  bool validatePetAge(String? value) {
    if (value!.isEmpty == true) {
      return false;
    }
    final int age = int.tryParse(value) ?? 0;
    if (age <= 0) {
      return false;
    }
    return true;
  }

  bool? validatePetSpecie() {
    if (_selectedSpecie == null || _selectedSpecie!.name.isEmpty == true) {
      return false;
    }
    return true;
  }

  bool? validatePetBreed() {
    if (_selectedBreed == null || _selectedBreed!.name.isEmpty == true) {
      return false;
    }
    return true;
  }
}
