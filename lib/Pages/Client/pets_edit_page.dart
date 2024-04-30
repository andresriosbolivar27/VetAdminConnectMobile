// Create an EditPetPage to edit the selected pet
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPetPage extends StatefulWidget {
  final String petName;

  const EditPetPage({Key? key, required this.petName}) : super(key: key);

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final _newPetNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newPetNameController.text = widget.petName; // Initialize with the petName
  }

  @override
  void dispose() {
    _newPetNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.petName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPetNameController,
              decoration: const InputDecoration(
                labelText: 'Nuevo nombre de la mascota',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement logic to update the pet name (e.g., in a database)
                // For now, just show a snackbar with the new name and navigate back
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Actualizado a ${_newPetNameController.text}'),
                  ),
                );
                Navigator.pop(context); // Navigate back to the list page
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}