import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Pet.dart';
import 'package:vetadminconnectmobile/Pages/Client/pets_detail_page.dart';
import 'package:vetadminconnectmobile/Pages/Client/pets_edit_page.dart';
import 'package:vetadminconnectmobile/Repository/client_api/client_http_api_repository.dart';

class PetsPage extends StatefulWidget {
   const PetsPage({super.key});
  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  Client? _client;

  void _showMsg(String msg){
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void _addButtonClicked() {
    setState(() {
      _showMsg("Nueva Mascota");
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchClientData(); // Fetch client data on initialization
  }

  Future<void> _fetchClientData() async {
    try {
      final clientRepository = ClientHttpApiRepository();
      final apiResponse = await clientRepository.getClient(1);
      if (apiResponse.wasSuccess) {
        setState(() {
          _client = apiResponse.result;
        });
      } else {
        _showMsg(apiResponse.exceptions!.first.exception ?? "Error fetching client data");
      }
    } catch (error) {
      _showMsg("Error: $error"); // Handle general errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _client!.pets.length,
        itemBuilder: (context, index) {
          final petName = _client!.pets[index].name;
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
      floatingActionButton: FloatingActionButton(
          onPressed: _addButtonClicked, child: const Icon(Icons.add)),
    );
  }
}



