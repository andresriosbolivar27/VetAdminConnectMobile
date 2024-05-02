import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Pet.dart';
import 'package:vetadminconnectmobile/Pages/Client/pets_detail_page.dart';
import 'package:vetadminconnectmobile/Pages/Client/pets_edit_page.dart';
import 'package:vetadminconnectmobile/Repository/client_api/client_http_api_repository.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({Key? key}) : super(key: key);

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  Client? _client;
  final _searchController = TextEditingController();
  List<Pet> _filteredPets = [];

  @override
  void initState() {
    super.initState();
    _fetchClientData();
  }

  Future<void> _fetchClientData() async {
    try {
      final clientRepository = ClientHttpApiRepository();
      final apiResponse = await clientRepository
          .getClient('2bb67fba-3e19-4c66-b697-c73865d95dd7');
      if (apiResponse.wasSuccess) {
        setState(() {
          _client = apiResponse.result;
          _filteredPets = _client!.pets;
        });
      } else {
        _showMsg(apiResponse.exceptions!.first.exception ??
            "Error fetching client data");
      }
    } catch (error) {
      _showMsg("Error: $error");
    }
  }

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

  void _navigateToVeterinarioDetails(Pet petItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetDetailsPage(pet: petItem),
      ),
    );
  }

  void _filterPets(String searchTerm) {
    setState(() {
      _filteredPets = _client!.pets
          .where((pet) =>
              pet.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar mascota...',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: _filterPets,
        ),
      ),
      body: _client != null && _client!.pets.isNotEmpty
          ? ListView.builder(
              itemCount: _filteredPets.length,
              itemBuilder: (context, index) {
                final petItem = _filteredPets[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  title: Text(petItem.name),
                  subtitle: Text(petItem.breedName),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Editar':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPetPage(pet: petItem),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Editando ${petItem.name}'),
                            ),
                          );
                          break;
                        case 'Eliminar':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Eliminado ${petItem.name}'),
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
                  onTap: () {
                    _navigateToVeterinarioDetails(petItem);
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addButtonClicked,
        child: const Icon(Icons.add),
      ),
    );
  }
}
