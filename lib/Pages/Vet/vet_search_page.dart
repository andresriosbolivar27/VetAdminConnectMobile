import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vetadminconnectmobile/Model/PaginationDto.dart';
import 'package:vetadminconnectmobile/Model/Vet.dart';
import 'package:vetadminconnectmobile/Pages/Vet/vet_detail_page.dart';
import 'package:vetadminconnectmobile/Repository/vet_api/vet_http_api_repository.dart';

class VetSearchPage extends StatefulWidget {
  const VetSearchPage({super.key});

  @override
  State<VetSearchPage> createState() => _VetSearchPageState();
}

class _VetSearchPageState extends State<VetSearchPage> {
  var pagination = PaginationDto(null, 1, 10, '');
  var vetApi = VetHttpApiRepository();
  final _searchController = TextEditingController();
  List<Vet> _especialistas = [];
  List<Vet> _filteredEspecialistas = [];
  bool _hasMore = false;

  @override
  void initState() {
    super.initState();
    getVets();
    _searchController.addListener(() {
      _filterEspecialistas();
    });
  }

  Future<void> _loadMoreVets() async {
    if (_hasMore) {
      pagination.page++; // Increment page number
      await getVets(); // Fetch more vets
    }
  }

  Future<void> getVets() async {
    _hasMore = false;
    var response = await vetApi.getVets(pagination, '');
    if (response.wasSuccess) {
      setState(() {
        _hasMore = true;
        _especialistas = response.result!;
        _filteredEspecialistas+= _especialistas;
        _hasMore = response.result!.length == pagination.recordsNumber;
      });
    }
  }

  void _filterEspecialistas() {
    final searchTerm = _searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      setState(() {
        _filteredEspecialistas = _especialistas;
      });
      return;
    }

    setState(() {
      _filteredEspecialistas = _especialistas.where((especialista) {
        final fullNameLower = especialista.fullName.toLowerCase();
        final cityNameLower = especialista.cityName.toLowerCase();
        final specialitiesLower = especialista.vetSpecialities
            .map((speciality) => speciality.name.toLowerCase())
            .toList();

        if (fullNameLower.contains(searchTerm) ||
            cityNameLower.contains(searchTerm)) {
          return true;
        }

        if (specialitiesLower.isNotEmpty) {
          for (final speciality in specialitiesLower) {
            if (speciality.contains(searchTerm)) {
              return true;
            }
          }
        }

        return false;
      }).toList();
    });
  }

  void _navigateToVeterinarioDetails(Vet veterinario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VeterinarioDetailsPage(veterinario: veterinario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Nombre, especialidad o ciudad...',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.extentAfter == 0) {
                _loadMoreVets(); // Load more vets when reaching the end of the list
              }
              return false;
            },
            child: ListView.builder(
              itemCount: _filteredEspecialistas.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _filteredEspecialistas.length) {
                  if (_hasMore) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Display progress indicator while loading more
                  } else {
                    return const Center(
                        child: Text(
                            'No se encontraron más veterinarios')); // Display message when all vets are loaded
                  }
                }
                final veterinario = _filteredEspecialistas[index];
                var conse = Random().nextInt(100);
                veterinario.address = 'https://picsum.photos/200/30$conse';
                return Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: InkWell(
                    onTap: () => _navigateToVeterinarioDetails(veterinario),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    Image.network(veterinario.address).image,
                                radius: 30,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons
                                            .person_outline),
                                        const SizedBox(width: 8.0),
                                        Text(veterinario.fullName,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        const Icon(Icons
                                            .place_outlined),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            veterinario.cityName,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic)),
                                      ],
                                    ),
                                    const SizedBox(height: 2.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.work_outline),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Chip(
                                                    label: Text(
                                                      veterinario.vetSpecialities.first.name,
                                                      style: const TextStyle(
                                                        fontSize: 11, color: Colors.black,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    side: BorderSide.none,
                                                    padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                                                  ), const
                                                  Text(
                                                    '-',
                                                    style: TextStyle(fontSize: 13, color: Colors.black),
                                                  ),
                                                   Chip(
                                                    label: Text(
                                                      veterinario.vetSpecialities.last.name,
                                                      style: const TextStyle(
                                                        fontSize: 11, color: Colors.black,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    side: BorderSide.none,
                                                    padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2.0),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_border_sharp),
                                        const SizedBox(width: 8.0),
                                        RatingBar.builder(
                                          initialRating:
                                          veterinario.averageRating,
                                              //Random().nextDouble() * 5,
                                          onRatingUpdate: (rating) {
                                          },
                                          minRating: 1,
                                          maxRating: 5,
                                          allowHalfRating: true,
                                          ignoreGestures: true,
                                          itemSize: 15,
                                          itemCount: 5,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
