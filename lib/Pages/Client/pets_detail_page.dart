import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PetDetailsPage extends StatelessWidget {
  final String petName;

  const PetDetailsPage({Key? key, required this.petName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de $petName'),
      ),
      body: Center(
        child: Text('Aquí se mostrarían los detalles de la mascota $petName'),
      ),
    );
  }
}