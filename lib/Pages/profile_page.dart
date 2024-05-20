import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetadminconnectmobile/Services/TokenService.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TokenService _tokenService = TokenService();
  late String _name = '';
  late String _lastName = '';
  late String _email = '';
  late String _userType = '';
  File? _imageFile;
  late String _profileImageBase64;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _lastName = prefs.getString('lastName') ?? '';
      _email = prefs.getString('email') ?? '';
      _userType = prefs.getString('userType') ?? '';
    });
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

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Advertencia"),
          content: const Text("¿Está seguro que desea cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _tokenService.deleteSecureData();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nombre Usuario',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          'Correo electrónico: $_email',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          'Tipo de usuario: $_userType',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 16, color: Colors.blueAccent)),
                onPressed: () {
                  // Implementar navegación a la página de edición del perfil
                },
                child: const Text('Editar Perfil'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 16, color: Colors.blueAccent)),
                onPressed: () async {
                  await _logout(context);
                },
                child: const Text('Cerrar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
