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

  void _showMsg(String msg) {
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
      final apiResponse = await clientRepository.getClient('2bb67fba-3e19-4c66-b697-c73865d95dd7');
      if (apiResponse.wasSuccess) {
        setState(() {
          _client = apiResponse.result;
        });
      } else {
        _showMsg(apiResponse.exceptions!.first.exception ??
            "Error fetching client data");
      }
    } catch (error) {
      _showMsg("Error: $error"); // Handle general errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _client != null && _client!.pets.isNotEmpty
          ? ListView.builder(
              itemCount: _client!.pets.length,
              itemBuilder: (context, index) {
                final petItem = _client!.pets[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailsPage(pet: petItem),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(petItem.name),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'Editar':
                            // Implement edit functionality here
                            // (e.g., navigate to an edit screen)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPetPage(petName: petItem.name),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Editing $petItem.name'),
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
                                content: Text('Deleted $petItem.name'),
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
            )
          : const Center(
              child: CircularProgressIndicator(), // Show error message
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addButtonClicked,
        child: const Icon(Icons.add),
      ),
    );
  }
}
