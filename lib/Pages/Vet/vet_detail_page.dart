import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Pages/Vet/vet_search_page.dart';

class VeterinarioDetailsPage extends StatelessWidget {
  final Especialista veterinario;

  const VeterinarioDetailsPage({Key? key, required this.veterinario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ${veterinario.nombre}'),
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
                  veterinario.imagen,
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
                      veterinario.nombre,
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
                          'Edad: ${veterinario.nombre} años',
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
                          'Especialidad: ${veterinario.especialidad}',
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
                          'Ubicación: ${veterinario.ubicacion}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Add more details about the veterinarian as needed
            ],
          ),
        ),
      ),
    );
  }
}