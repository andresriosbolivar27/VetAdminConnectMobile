import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/auth_api_repository.dart';
import '../utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Genre { male, female }

class _RegisterPageState extends State<RegisterPage> {
  //final AccountApi _accountApi = AccountApi();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repPassword = TextEditingController();
  final _city = TextEditingController();

  bool _esAccionFavorite = false,
      _esAventuraFavorite = false,
      _esCienciaFiccionFavorite = false;
  bool _esDramaFavorite = false,
      _esFantasiaFavorite = false,
      _esRomanceFavorite = false;
  bool _esSuspensoFavorite = false, _esTerrorFavorite = false;

  bool _passwordVisible = true;
  bool _repPasswordVisible = true;

  String _birthDate = "Fecha de Nacimiento";

  Genre? _genre = Genre.male;
  String _genreSelected = 'Masculino';

  final List<String> _cities = [
    'Barranquilla',
    'Bogotá',
    'Cali',
    'Medellín',
    'Pereira',
  ];

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/images/logo.png'),
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
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.person)),
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
                DropdownMenu<String>(
                  width: 330,
                  enableFilter: true,
                  requestFocusOnTap: true,
                  label: const Text("Ciudad"),
                  onSelected: (String? city) {
                    setState(() {
                      _city.text = city!;
                    });
                  },
                  dropdownMenuEntries:
                      _cities.map<DropdownMenuEntry<String>>((String city) {
                    return DropdownMenuEntry<String>(value: city, label: city);
                  }).toList(),
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
                  "Géneros literarios favoritos",
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Acción'),
                        value: _esAccionFavorite,
                        selected: _esAccionFavorite,
                        onChanged: (bool? value) {
                          setState(() {
                            _esAccionFavorite = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Aventura'),
                        value: _esAventuraFavorite,
                        selected: _esAventuraFavorite,
                        onChanged: (bool? value) {
                          setState(() {
                            _esAventuraFavorite = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Ciencia ficción'),
                        value: _esCienciaFiccionFavorite,
                        selected: _esCienciaFiccionFavorite,
                        onChanged: (bool? value) {
                          setState(() {
                            _esCienciaFiccionFavorite = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Drama'),
                        value: _esDramaFavorite,
                        selected: _esDramaFavorite,
                        onChanged: (bool? value) {
                          setState(() {
                            _esDramaFavorite = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Fantasía'),
                        value: _esFantasiaFavorite,
                        selected: _esFantasiaFavorite,
                        onChanged: (bool? value) {
                          setState(() {
                            _esFantasiaFavorite = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Romance'),
                        value: _esRomanceFavorite,
                        selected: _esRomanceFavorite,
                        onChanged: (bool? value) {
                          setState(() {
                            _esRomanceFavorite = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Suspenso'),
                        value: _esSuspensoFavorite,
                        selected: _esSuspensoFavorite,
                        onChanged: (bool? value) {
                          setState(() {
                            _esSuspensoFavorite = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Terror'),
                        value: _esTerrorFavorite,
                        selected: _esTerrorFavorite,
                        onChanged: (bool? value) {
                          setState(() {
                            _esTerrorFavorite = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
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
           //   var user = User(_name.text, _email.text, _password.text);
           //   _saveUser(user);
              registerUser();
           //   Navigator.pop(context);
            } else {
              showMessage("ERROR: Las contraseñas no son iguales");
            }
          }
        }
      }
    });
  }

  Future<void> registerUser() async {
    //var result = await _accountApi. registerUser(_email.text, _password.text);
    print('registradp');
    //valido que result si es un uid osea que fue exitoso
    //var user = User (result, _name.text, _email.text);
    //createUser(user);
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

//Marzo 21 de 2024
//Abril 4 de 2024
