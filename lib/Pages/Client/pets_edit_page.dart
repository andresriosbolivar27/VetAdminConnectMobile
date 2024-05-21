import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
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
import 'package:vetadminconnectmobile/Services/TokenService.dart';

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
  final TokenService _tokenService = TokenService();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late GenderType _selectedGender;
  late Especie? _selectedSpecie = null;
  late Raza? _selectedBreed = null;
  late SizeType _selectedSize;
  File? _imageFile;
  File? _imageCloudFile;
  String? _imageCloudFileBase64;
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
    if (widget.pet.photo != null && widget.pet.photo!.isNotEmpty) {
      _imageCloudFile = File(widget.pet.photo!);
      _loadImageFromNetwork();
    }
    _loadData();
  }

  Future<void> _loadData2() async {
    final fetchedBreeds = await _fetchRazas(widget.pet.specieId);
    if (fetchedBreeds.wasSuccess) {
      setState(() {
        razas = fetchedBreeds.result!;
        _selectedBreed = razas.firstWhere((e) => e.id == widget.pet.breedId);
        _loadData2();
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
                backgroundImage: _loadImage(),
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
    File fileImage;

    if (_imageFile != null) {
      petImage = base64Encode(_imageFile!.readAsBytesSync());
    }

    if (_imageFile != null) {
      petImage = base64Encode(_imageFile!.readAsBytesSync());
    } else if (_imageCloudFile != null) {
      petImage = _imageCloudFileBase64;
    } else {
      petImage = null;
    }

    List<Pet> pets = [
      Pet(
        id: widget.pet.id,
        name: petName,
        age: petAge,
        genderType: petGenderType.index,
        specieId: petSpecieId,
        breedId: petBreedId,
        photo: petImage,
        sizeType: petSize.index,
      )
    ];

    Client client = Client.empty();
    client.pets = pets;

    var token = await _tokenService.getTokenData('token');
    var result = await _clientApi.editPets(client, token['token']);

    if (result.wasSuccess) {
      token.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mascota Actualizada'),
        ),
      );
      Navigator.pop(context, true);
    }

    if (!result.wasSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al editar mascota'),
        ),
      );
    }
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

  ImageProvider<Object>? _loadImage() {
    ImageProvider<Object>? image;
    setState(() {
      if (_imageFile != null) {
        image = FileImage(_imageFile!);
      } else if (_imageCloudFile != null) {
        image = NetworkImage(_imageCloudFile!.path);
      } else {
        image = null;
      }
    });

    return image;
  }

  Future<void> _loadImageFromNetwork() async {
    try {
      http.Response response = await http.get(Uri.parse(widget.pet.photo!));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
          _imageCloudFileBase64 = base64Encode(bytes);
      } else {
        print(
            'Error al cargar la imagen desde la nube: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar la imagen desde la nube: $e');
    }
  }
}
