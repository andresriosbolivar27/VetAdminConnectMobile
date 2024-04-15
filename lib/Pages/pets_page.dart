import 'package:flutter/material.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  // Sample pet list (replace with your actual data source)
  final List<String> pets = ['Cat', 'Dog', 'Rabbit', 'Fish'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final petName = pets[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetDetailsPage(petName: petName),
                ),
              );
            },
            child: ListTile(
              title: Text(petName),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Editar':
                    // Implement edit functionality here
                    // (e.g., navigate to an edit screen)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPetPage(petName: petName),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Editing $petName'),
                        ),
                      );
                      break;
                    case 'Eliminar':
                    // Implement delete functionality here
                    // (e.g., remove the pet from the list)
                    //   setState(() {
                    //     pets.removeAt(index);
                    //   });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleted $petName'),
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Editar',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Eliminar',
                      child: Text('Eliminar'),
                    ),
                  ];
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Create a PetDetailsPage to display details of the selected pet
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

// Create an EditPetPage to edit the selected pet
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

