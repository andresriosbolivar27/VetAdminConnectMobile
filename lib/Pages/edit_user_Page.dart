import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vetadminconnectmobile/Model/City.dart';
import 'package:vetadminconnectmobile/Model/Country.dart';
import 'package:vetadminconnectmobile/Model/Departamento.dart';
import 'package:vetadminconnectmobile/Model/User.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_http_api_repository.dart';
import 'package:vetadminconnectmobile/Repository/city_api/city_http_api_repository.dart';
import 'package:vetadminconnectmobile/Repository/country_api/country_http_api_repository.dart';
import 'package:vetadminconnectmobile/Repository/state_api/state_http_api_repository.dart';
import 'package:http/http.dart' as http;
import 'package:vetadminconnectmobile/Services/TokenService.dart';

import '../utils.dart';

class EditUserPage extends StatefulWidget {
  final User user;

  const EditUserPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

enum Genre { male, female }
enum UserType {
  client(1, 'Cliente'),
  vet(2, 'Veterinario');

  const UserType(this.id, this.roleName);
  final int id;
  final String roleName;
}

class _EditUserPageState extends State<EditUserPage> {
  final _accountApi = AuthHttpApiRepository();
  final _countryApiRepository = CountryHttpApiRepository();
  final _stateApiRepository = StateHttpApiRepository();
  final _cityApiRepository = CityHttpApiRepository();
  final TokenService _tokenService = TokenService();

  late TextEditingController _name;
  late TextEditingController _lastName;
  late TextEditingController _document;
  late TextEditingController _phone;
  late TextEditingController _address;
  late TextEditingController _country;
  late TextEditingController _state;
  late TextEditingController _city;
  late TextEditingController _email;
  late TextEditingController _roleController;
  late TextEditingController _countryId;
  late TextEditingController _stateId;
  late TextEditingController _cityId;
  late TextEditingController _cityIdSearch;
  String _birthDate = "Fecha de Nacimiento";
  Genre? _genre;
  String _genreSelected = 'Masculino';
  File? _imageFile;
  File? _imageCloudFile;
  String? _imageCloudFileBase64;
  int userTypeSelected = 0;
  List<Country> _countries = [];
  List<Departamento> _states = [];
  List<City> _cities = [];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.firstName);
    _lastName = TextEditingController(text: widget.user.lastName);
    _document = TextEditingController(text: widget.user.document);
    _phone = TextEditingController(text: widget.user.phoneNumber);
    _address = TextEditingController(text: widget.user.address);
    _country = TextEditingController();
    _state = TextEditingController();
    _city = TextEditingController();
    _email = TextEditingController(text: widget.user.email);
    _roleController = TextEditingController();
    _countryId = TextEditingController(text: '47' /*widget.user.countryId.toString()*/);
    _stateId = TextEditingController(text:'776'/*widget.user.stateId.toString()*/);
    _cityId = TextEditingController(text: widget.user.cityId.toString());
    _cityIdSearch = TextEditingController(text: widget.user.cityId.toString());
    userTypeSelected = widget.user.userType;
    if (widget.user.photo != null && widget.user.photo!.isNotEmpty) {
      _imageCloudFile = File(widget.user.photo!);
      _loadImageFromNetwork();
    }
  }

  String _dateConverter(DateTime newDate) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(newDate);
    return dateFormatted;
  }

  void _showSelectDate() async {
    final DateTime? newDate = await showDatePicker(
        context: context,
        locale: const Locale("es", "CO"),
        initialDate: DateTime.now(),
        firstDate: DateTime(1924, 01, 01),
        lastDate: DateTime.now(),
        helpText: _birthDate);
    if (newDate != null) {
      setState(() {
        _birthDate = "Fecha de nacimiento ${_dateConverter(newDate)}";
      });
    }
  }

  void showMessage(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _loadImageFromNetwork() async {
    try {
      http.Response response = await http.get(Uri.parse(widget.user.photo!));
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

  @override
  Widget build(BuildContext context) {
    double dropdownWidth = MediaQuery.of(context).size.width * 0.91;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ${widget.user.firstName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/images/LogoLogin.png'),
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombres',
                      prefixIcon: Icon(Icons.person)),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _lastName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Apellidos',
                      prefixIcon: Icon(Icons.person)),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _document,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Documento Identidad',
                      prefixIcon: Icon(Icons.perm_identity)),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _phone,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Telefono',
                      prefixIcon: Icon(Icons.phone)),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _address,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Direccion',
                      prefixIcon: Icon(Icons.location_on)),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email),
                      helperText: '*Campo obligatorio'),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                  value!.isValidEmail() ? null : 'Correo invalido',
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CountryStateCityPicker(
                    country: _country,
                    state: _state,
                    city: _city,
                    countryId: _countryId,
                    stateId: _stateId,
                    cityId: _cityId,
                    cityIdSearch:_cityIdSearch,
                    dialogColor: Colors.grey.shade200,
                    textFieldDecoration: const InputDecoration(
                        filled: false,
                        suffixIcon: Icon(Icons.arrow_downward_rounded),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignCenter)))),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Seleccione su género",
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                          title: const Text('Masculino'),
                          value: Genre.male,
                          groupValue: _genre,
                          onChanged: (Genre? value) {
                            setState(() {
                              _genre = value;
                              _genreSelected = 'Masculino';
                            });
                          }),
                    ),
                    Expanded(
                      child: RadioListTile(
                          title: const Text('Femenino'),
                          value: Genre.female,
                          groupValue: _genre,
                          onChanged: (Genre? value) {
                            setState(() {
                              _genre = value;
                              _genreSelected = 'Femenino';
                            });
                          }),
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  value: userTypeSelected,
                  items: UserType.values
                      .map((UserType role) {
                    return DropdownMenuItem(
                      value: role.id,
                      child: Text(role.roleName),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      userTypeSelected = value!;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Tipo Usuario',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  child: Text(_birthDate),
                  onPressed: () {
                    _showSelectDate();
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Seleccione una imagen",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16.0),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _loadImage(),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.blueAccent),
                    onPressed: () {
                      _showImagePicker(context);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: _onSaveButtonClicked,
                  child: const Text("Actualizar", style: TextStyle(color: Colors.blueAccent),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      final compressedImage = await _compressImage(image);
      setState(() {
        _imageFile = compressedImage;
      });
    }
  }

  Future<File?> _compressImage(XFile imageFile) async {
    final imagePath = imageFile.path;
    final compresedFIle = File(imagePath);
    final picture = await FlutterImageCompress.compressWithFile(
      imagePath,
      quality:40, // Adjust quality as needed (lower = smaller size)
    );

    await compresedFIle.writeAsBytes(picture!);
    return compresedFIle;
  }

  void _onSaveButtonClicked() {
    setState(() {
      if (_email.text.isEmpty) {
        showMessage("ERROR: Debe digitar correo electrónico");
      } else {
        if (!_email.text.isValidEmail()) {
          showMessage("ERROR: El correo electrónico no es válido");
        } else {
          saveUser();
          Navigator.pop(context, true);
        }
      }
    });
  }

  Future<void> saveUser() async {
    String? userImage;

    if (_imageFile != null) {
      userImage = base64Encode(_imageFile!.readAsBytesSync());
    } else if (_imageCloudFile != null) {
      userImage = _imageCloudFileBase64;
    } else {
      userImage = null;
    }

    var client = User(
        widget.user.id,
        _document.text,
        _name.text,
        _lastName.text,
        _address.text,
        userImage,
        userTypeSelected,
        int.parse(_cityId.text),
        _birthDate,
        _email.text,
        _email.text,
        widget.user.password,
        widget.user.password,
        _phone.text
    );

    var token = await _tokenService.getTokenData('token');
    var result = await _accountApi.updateClientApi(client, token['token']);

    if (result.wasSuccess) {
      token.clear();
      await _tokenService.updateSecureData(client.toJson(),'clientData');
      showMessage('La información del usuario ha sido actualizada con éxito.');
    }
  }
}

extension on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
