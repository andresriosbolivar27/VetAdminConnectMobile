import 'dart:math';

import 'package:flutter/material.dart';
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
  bool _hasMore = true;
  bool _isLoading = false;
  Future<void>? _fetchVetsDataFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchVetsDataFuture = getVets();
    });

    _searchController.addListener(() {
      _filterEspecialistas();
    });
  }

  Future<void> _loadMoreVets() async {
    if (_hasMore && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      pagination.page++;
      await getVets();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getVets() async {
    var response = await vetApi.getVets(pagination, '');
    if (response.wasSuccess) {
      setState(() {
        _especialistas.addAll(response.result!);
        _filteredEspecialistas = _especialistas;
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

  void _navigateToVeterinarioDetails(Vet veterinario) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VeterinarioDetailsPage(veterinario: veterinario),
      ),
    );

    if (result != null && result) {
      setState(() {
        _especialistas = [];
        _filteredEspecialistas = [];
        _fetchVetsDataFuture = getVets();
      });
    }
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
      body: FutureBuilder<void>(
        future: _fetchVetsDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'No hay veterinarios',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            if (_especialistas == null ||  _filteredEspecialistas.isEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'No hay veterinarios',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==  scrollInfo.metrics.maxScrollExtent &&
                      _hasMore &&
                      !_isLoading) {
                    _loadMoreVets();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: _filteredEspecialistas.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _filteredEspecialistas.length) {
                      if (_hasMore) {
                        return const Center(
                            child:
                            CircularProgressIndicator());
                      } else {
                        return const Center(
                            child: Text(
                                'No se encontraron más veterinarios'));
                      }
                    }
                    final veterinario = _filteredEspecialistas[index];
                    var conse = Random().nextInt(100);
                    veterinario.address = 'https://picsum.photos/200/30$conse';

                    return _buildListItem(veterinario);
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildListItem(Vet veterinario) {
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
                    backgroundImage: Image.network(veterinario.address).image,
                    radius: 30,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_outline),
                            const SizedBox(width: 8.0),
                            Text(
                              veterinario.fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined),
                            const SizedBox(width: 8.0),
                            Text(
                              veterinario.cityName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
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
                                          veterinario
                                              .vetSpecialities.first.name,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        side: BorderSide.none,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 1.0, vertical: 1.0),
                                      ),
                                      const Text(
                                        '-',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                      Chip(
                                        label: Text(
                                          veterinario.vetSpecialities.last.name,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        side: BorderSide.none,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 1.0, vertical: 1.0),
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
                              initialRating: veterinario.averageRating,
                              onRatingUpdate: (rating) {},
                              minRating: 1,
                              maxRating: 5,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemSize: 15,
                              itemCount: 5,
                              itemBuilder: (context, _) => const Icon(
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
  }
}
