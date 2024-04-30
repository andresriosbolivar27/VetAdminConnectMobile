import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Model/Pet.dart';

class PetDetailsPage extends StatelessWidget {
  final Pet pet;

  const PetDetailsPage({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ${pet.name}'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  'https://media.istockphoto.com/id/1499919152/es/foto/retrato-lindo-perro-cachorro-shiba-inu-mirando-a-la-c%C3%A1mara-sonriendo-aislado-sobre-fondo-azul.jpg?s=1024x1024&w=is&k=20&c=gRaWo1lj8EROHBFj2LZGY16HGx_2Nfz023YWt5ah1uU=',
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pet name with bigger font and accent color
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Details section with icons and better spacing
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          'Edad: ${pet.age} años',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.pets_outlined, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          'Raza: ${pet.breedName}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.wc_outlined, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          'Sexo: ${pet.genderTypeDescription}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}