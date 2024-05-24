import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetadminconnectmobile/Model/Vet.dart';

class VeterinarioDetailsPage extends StatefulWidget {
  final Vet veterinario;

  const VeterinarioDetailsPage({Key? key, required this.veterinario})
      : super(key: key);

  @override
  _VeterinarioDetailsPageState createState() => _VeterinarioDetailsPageState();
}

class _VeterinarioDetailsPageState extends State<VeterinarioDetailsPage> {
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _rating = Random().nextDouble() * 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ${widget.veterinario.fullName}'),
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
                      widget.veterinario.fullName,
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
                          'Telefono: ${widget.veterinario.phoneNumber}',
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
                          'Especialidad: ${widget.veterinario.vetSpecialities.isEmpty ? '' : widget.veterinario.vetSpecialities.first.name}',
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
                          'Ubicación: ${widget.veterinario.cityName}',
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
                      initialRating: _rating,
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
                        setState(() {
                          _rating = rating;
                        });
                        _showRatingDialog(context, rating);
                      },
                    ),
                    const SizedBox(height: 10),
                    // Botón de WhatsApp
                    IconButton(
                      onPressed: () {
                        _launchWhatsApp(widget.veterinario.phoneNumber, context);
                      },
                      icon: Image.asset(
                        'assets/images/whatsapp_logo.png', // Replace with your actual image filename
                        width: 50, // Adjust the size as needed
                        height: 50, // Adjust the size as needed
                      ),
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
    String whatsappURlAndroid = "whatsapp://send?phone=$phone&text="
        "Estoy interesado en agendar una consulta:";
    if (whatsappURlAndroid.isNotEmpty) {
      await launchUrl(Uri.parse(whatsappURlAndroid));
    } else {
      // Handle no WhatsApp installed scenario
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("WhatsApp no está instalado"),
          content: const Text(
              "Necesitas tener WhatsApp instalado para enviar mensajes."),
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

  void _showRatingDialog(BuildContext context, double rating) {
    final _formKey = GlobalKey<FormState>();
    final _commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Calificación'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) =>
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (newRating) {
                          setState(() {
                            rating = newRating;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          labelText: 'Comentario',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El comentario es obligatorio';
                          }
                          return null;
                        },
                        maxLines: 3,
                      ),
                    ],
                  ),
                )
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final comment = _commentController.text;
                      print('Calificación: $rating');
                      print('Comentario: $comment');

                      // Simulación de envío al servidor

                      Navigator.pop(context); // Cerrar el diálogo
                      _showSnackBar(rating); // Mostrar snackbar
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSnackBar(double rating) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Calificación registrada con éxito',
        ),
      ),
    );
  }
}
