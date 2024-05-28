import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Pet.dart';
import 'package:vetadminconnectmobile/Pages/Client/pets_add_page.dart';
import 'package:vetadminconnectmobile/Pages/Client/pets_detail_page.dart';
import 'package:vetadminconnectmobile/Pages/Client/pets_edit_page.dart';
import 'package:vetadminconnectmobile/Repository/client_api/client_http_api_repository.dart';
import 'package:vetadminconnectmobile/Services/TokenService.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({Key? key}) : super(key: key);

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  Client? _client;
  final _searchController = TextEditingController();
  List<Pet> _filteredPets = [];
  Future<void>? _fetchClientDataFuture;
  final TokenService _tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    _fetchClientDataFuture = _fetchClientData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar mascota...',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: _filterPets,
        ),
      ),
      body: FutureBuilder<void>(
        future: _fetchClientDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (_client == null || _client!.pets.isEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'No hay mascotas',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }else{
              return ListView.builder(
                itemCount: _filteredPets.length,
                itemBuilder: (context, index) {
                  final petItem = _filteredPets[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        petItem?.photo?.isNotEmpty == true
                            ? petItem!.photo!
                            : 'https://via.placeholder.com/150',
                      ),
                    ),
                    title: Text(petItem.name),
                    subtitle: Text(petItem.breedName!),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'Editar':
                            _editButtonClicked(petItem);
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
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addButtonClicked,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _fetchClientData() async {
    try {
      final clientRepository = ClientHttpApiRepository();
      var token = await _tokenService.getTokenData('decodedToken');
      String? userId = token['UserId'] as String;
      final ApiResponse<Client> apiResponse;

      apiResponse = await clientRepository.getClient(userId, '');

      if (apiResponse.wasSuccess) {
        var client = Client(
            apiResponse.result!.id,
            apiResponse.result!.document,
            apiResponse.result!.firstName,
            apiResponse.result!.lastName,
            apiResponse.result!.address,
            apiResponse.result!.photo,
            apiResponse.result!.userType,
            apiResponse.result!.cityId,
            apiResponse.result!.cityName,
            apiResponse.result!.userName,
            apiResponse.result!.email,
            '',
            '',
            apiResponse.result!.phoneNumber,
            apiResponse.result!.clientId,
            []).toJson();
        await _tokenService.saveSecureData(client , 'clientData');
        setState(() {
          userId = null;
          token = {};
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

  void _addButtonClicked() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetPage(_client!.clientId),
      ),
    );
    if (result != null && result) {
      setState(() {
        _fetchClientDataFuture = _fetchClientData();
      });
    }
  }

  void _editButtonClicked(Pet pet) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPetPage(pet: pet),
      ),
    );
    if (result != null && result) {
      setState(() {
        _fetchClientDataFuture = _fetchClientData();
      });
    }
  }

  void _navigateToVeterinarioDetails(Pet petItem) async {
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
}
