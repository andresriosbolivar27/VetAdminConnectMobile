import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Generic/app_exception.dart';
import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';
import 'package:vetadminconnectmobile/Pages/register_page.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_http_api_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../Model/User.dart';
import 'home_page_tabs_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _authApiRepository = AuthHttpApiRepository();
  late Map<String, dynamic> decodedToken;
  bool _passwordVisible = true;
  User userLoaded = User.empty();

  void _showMsg(String msg){
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _onLoginButtonClicked() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showMsg("Debe digitar correo electrónico y contraseña");
    } else if (!_email.text.isValidEmail()) {
      _showMsg("El correo electrónico es inválido");
    } else {
      try{
        LoginDto loginDto = LoginDto(email: _email.text, password: _password.text);
        final result = await _authApiRepository.loginApi(loginDto, '');
        if (!result.wasSuccess) {
          _showMsg(result.exceptions!.first.exception);
        } else if(result.wasSuccess){
          print('token');
          decodedToken = JwtDecoder.decode(result.result!.token);
          print('Email: ${decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']}');
          print('Rol: ${decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']}');
          print('Documento: ${decodedToken['Document']}');
          print('Nombre: ${decodedToken['FirstName']} ${decodedToken['LastName']}');
          print('Dirección: ${decodedToken['Address']}');
          print('Ciudad ID: ${decodedToken['CityId']}');
          print('ID de usuario: ${decodedToken['UserId']}');
          print('Fecha de expiración: ${DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000)}'); // Convert exp timestamp to DateTime
          _showMsg("Bienvenido");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomePageTabsPage()));
        }
      }on SocketException catch(e) {
        _showMsg(e.toString());
      }on FormatException catch(e) {
        _showMsg("Error al procesar la respuesta del servidor: ${e.toString()}");
      }
      catch(e){
        switch (e.runtimeType) {
          case SocketException:
            _showMsg("¡No hay conexión a internet!");
            break;
          case FormatException:
            _showMsg("Error al procesar la respuesta del servidor: ${e.toString()}");
            break;
          case FetchDataException:
            _showMsg("Error durante la comunicación con el servidor: ${e.toString()}");
            break;
          case BadRequestException:
            _showMsg("Solicitud inválida: ${e.toString()}");
            break;
          case UnauthorisedException:
            _showMsg("Acceso no autorizado: ${e.toString()}");
            break;
          case InvalidInputException:
            _showMsg("Entrada inválida: ${e.toString()}");
            break;
          case NoInternetException:
            _showMsg("¡No hay conexión a internet!");
            break;
          default:
            print(e.toString());
            final deserialized =GetLoginResponse(e.toString());
            _showMsg(deserialized.exceptions!.first.exception);
        }
      }
    }
  }
  ApiResponse<TokenResult> GetLoginResponse(String response ){
  final deserialized = ApiResponse.fromJson(
      Map<String, dynamic>.from(jsonDecode(response)), (json) {
    // Assume 'UserData' class for the result based on your structure
    if (json is Map<String, dynamic>) {
      return  TokenResult.empty().fromJson(json);
    } else {
      throw Exception('Unsupported result type: ${json.runtimeType}');
    }
  });
  return deserialized;
}
/*  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = jsonDecode(prefs.getString("user")!);
    userLoaded = User.fromJson(userMap);
  }
*/
  @override
  void initState() {
//    _getUser();
    super.initState();
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
                  image: AssetImage('assets/images/LogoLogin.png'),
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email)),
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
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 32.0,
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed: _onLoginButtonClicked,
                  child: const Text("Iniciar sesión"),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  child: const Text('Regístrese'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
