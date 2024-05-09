import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetadminconnectmobile/Model/Vet.dart';

class VeterinarioDetailsPage extends StatelessWidget {
  final Vet veterinario;

  const VeterinarioDetailsPage({Key? key, required this.veterinario})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ${veterinario.fullName}'),
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  'https://picsum.photos/200/302',
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      veterinario.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.phone_android, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          'Telefono: ${veterinario.phoneNumber}',
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
                          'Especialidad: ${veterinario.vetSpecialities.isEmpty ? '' : veterinario.vetSpecialities.first.name}',
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
                          'Ubicación: ${veterinario.cityName}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // RatingBar
                    const Text(
                      'Calificación:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 30,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                        // Hacer algo con la calificación
                      },
                    ),
                    const SizedBox(height: 10),
                    // Botón de WhatsApp
                    ElevatedButton.icon(
                      onPressed: () {
                        _launchWhatsApp(veterinario.phoneNumber, context);
                      },
                      icon: Icon(
                        Icons.message,
                        color: Colors.green.shade500,
                      ),
                      label: Text(
                        'Enviar mensaje por WhatsApp',
                        style: TextStyle(color: Colors.green.shade500),
                      ), // Utiliza el color principal de tu app
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

  _launchWhatsApp(String phoneNumber, BuildContext context) async {
    final phone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    String whatsappURlAndroid =
        "whatsapp://send?phone=$phone&text="
        "Estoy interesado en agendar una consulta:";
      if (whatsappURlAndroid.isNotEmpty) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      }else {
      // Handle no WhatsApp installed scenario
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("WhatsApp no está instalado"),
          content: const Text("Necesitas tener WhatsApp instalado para enviar mensajes."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Aceptar"),
            ),
          ],
        ),
      );
    }
}
}
