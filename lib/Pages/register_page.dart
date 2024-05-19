import 'dart:convert';
import 'dart:io';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetadminconnectmobile/Model/City.dart';
import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Country.dart';
import 'package:vetadminconnectmobile/Model/Departamento.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_http_api_repository.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_repository.dart';
import 'package:vetadminconnectmobile/Repository/city_api/city_http_api_repository.dart';
import 'package:vetadminconnectmobile/Repository/country_api/country_http_api_repository.dart';
import 'package:vetadminconnectmobile/Repository/state_api/state_http_api_repository.dart';

import '../utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Genre { male, female }

enum UserType {
  client(1, 'Cliente'),
  vet(2, 'Veterinario');

  const UserType(this.id, this.roleName);
  final int id;
  final String roleName;
}

class _RegisterPageState extends State<RegisterPage> {
  final _accountApi = AuthHttpApiRepository();
  final _countryApiRepository = CountryHttpApiRepository();
  final _stateApiRepository = StateHttpApiRepository();
  final _cityApiRepository = CityHttpApiRepository();

  final _name = TextEditingController();
  final _lastName = TextEditingController();
  final _document = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _country = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repPassword = TextEditingController();
  final _roleController = TextEditingController();
  final _countryId = TextEditingController();
  final _stateId = TextEditingController();
  final _cityId = TextEditingController();
  bool _passwordVisible = true;
  bool _repPasswordVisible = true;
  String _birthDate = "Fecha de Nacimiento";
  Genre? _genre = Genre.male;
  String _genreSelected = 'Masculino';
  File? _profileImagePath;
  int userTypeSelected = 0;
  String? _profileImageBase64;


  List<Country> _countries = [];
  List<Departamento> _states = [];
  List<City> _cities = [];

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double dropdownWidth = MediaQuery.of(context).size.width * 0.91;
    return Scaffold(
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
                TextFormField(
                  controller: _password,
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      helperText: '*Campo obligatorio'),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _repPassword,
                  obscureText: _repPasswordVisible,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Repita la contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                          icon: Icon(_repPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _repPasswordVisible = !_repPasswordVisible;
                            });
                          }),
                      helperText: '*Campo obligatorio'),
                  keyboardType: TextInputType.text,
                ),
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
                DropdownMenu<UserType>(
                  width: dropdownWidth,
                  controller: _roleController,
                  requestFocusOnTap: true,
                  label: const Text('Tipo Usuario'),
                  onSelected: (UserType? userType) {
                    setState(() {
                      userTypeSelected = userType!.id;
                    });
                  },
                  dropdownMenuEntries: UserType.values
                      .map<DropdownMenuEntry<UserType>>((UserType role) {
                    return DropdownMenuEntry<UserType>(
                      value: role,
                      label: role.roleName,
                      enabled: role.name != 'Grey',
                    );
                  }).toList(),
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
                  backgroundImage:
                  _profileImagePath != null ? FileImage(_profileImagePath!) : null,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      _showImagePicker(context);
                    },
                  ),
                ),
                //_buildProfilePicture(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed: _onRegisterButtonClicked,
                  child: const Text("Registrar"),
                ),
              ],
            ),
          ),
        ),
      ),
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
        _profileImagePath = file;
        _profileImageBase64 = base64Encode(file.readAsBytesSync());
      });
    }
  }

  void _onRegisterButtonClicked() {
    setState(() {
      if (_password.text.isEmpty ||
          _repPassword.text.isEmpty ||
          _email.text.isEmpty) {
        showMessage("ERROR: Debe digitar correo electrónico y las contraseñas");
      } else {
        if (!_email.text.isValidEmail()) {
          showMessage("ERROR: El correo electrónico no es válido");
        } else {
          if (!Utils.isSizePasswordValid(_password.text)) {
            showMessage(
                "ERROR: La contraseña debe tener mas de 6 o más digitos");
          } else {
            if (_password.text == _repPassword.text) {
              registerUser();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Usuario registrado'),
                ),
              );
              Navigator.pop(context);
            } else {
              showMessage("ERROR: Las contraseñas no son iguales");
            }
          }
        }
      }
    });
  }

  Future<void> registerUser() async {
    var client = Client(
      '',
      _document.text,
      _name.text,
      _lastName.text,
      _address.text,
        _profileImageBase64,
      userTypeSelected,
      int.parse(_cityId.text),
      '',
      _email.text,
      _email.text,
      _password.text,
      _repPassword.text,
      _phone.text,
      0,
      []
    );

    var result = await _accountApi.createClientApi(client, '') ;

    if(result.wasSuccess){
      showMessage('Su cuenta ha sido creada con éxito. Se te ha enviado un correo electrónico con las instrucciones para activar tu usuario.');
    }
  }

  Future<void> _loadCountriesAsync() async {
    if (!_countries.any((element) => false)) {
      var countries = await _countryApiRepository.getCombo('');
      if (countries.wasSuccess) {
        _countries = countries.result!;
      }
    }
  }

  Future<void> _loadStatesAsync(int countryId) async {
    if (!_cities.any((element) => false)) {
      var states = await _stateApiRepository.getCombo(countryId, '');
      if (states.wasSuccess) {
        _states = states.result!;
      }
    }
  }

  Future<void> _loadCitiesAsync(int stateId) async {
    if (!_cities.any((element) => false)) {
      var cities = await _cityApiRepository.getCombo(stateId, '');
      if (cities.wasSuccess) {
        _cities = cities.result!;
      }
    }
  }

  // Future<void> createUser(User user) async{
  //   var result = await _firebaseApi.createUser(user);
  //   Navigator.pop(context);
  // }

  // void _saveUser(User user) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("user", jsonEncode(user));
  // }
}

extension on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
