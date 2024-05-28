import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vetadminconnectmobile/Model/PaginationDto.dart';
import 'package:vetadminconnectmobile/Model/Review.dart';
import 'package:vetadminconnectmobile/Repository/review_api/review_http_api_repository.dart';

class VetReviewsPage extends StatefulWidget {
  const VetReviewsPage({super.key});

  @override
  State<VetReviewsPage> createState() => _VetSearchPageState();
}

class _VetSearchPageState extends State<VetReviewsPage> {
  var pagination = PaginationDto(null, 1, 10, '');
  var _reviewApi = ReviewHttpApiRepository();
  final _searchController = TextEditingController();
  List<Review> _reviews = [];
  List<Review> _filteredReviews = [];
  bool _hasMore = true;
  bool _isLoading = false;
  Future<void>? _fetchReviewsDataFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchReviewsDataFuture = getReviews();
    });

    _searchController.addListener(() {
      _filterReviews();
    });
  }

  Future<void> _loadMoreReviews() async {
    if (_hasMore && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      pagination.page++;
      await getReviews();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getReviews() async {
    pagination.id = 1385;
    var response = await _reviewApi.getReviews(pagination, '');
    if (response.wasSuccess) {
      setState(() {
        _reviews.addAll(response.result!);
        _filteredReviews = _reviews;
        _hasMore = response.result!.length == pagination.recordsNumber;
      });
    }
  }

  void _filterReviews() {
    final searchTerm = _searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      setState(() {
        _filteredReviews = _reviews;
      });
      return;
    }

    setState(() {
      _filteredReviews = _reviews.where((review) {
        final fullNameLower = review.client?.fullName.toLowerCase();


        if (fullNameLower!.contains(searchTerm)) {
          return true;
        }

        return false;
      }).toList();
    });
  }

  void _navigateToReviewDetails(Review review) async {
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VeterinarioDetailsPage(veterinario: veterinario),
    //   ),
    // );
    //
    // if (result != null && result) {
    //   setState(() {
    //     _reviews = [];
    //     _filteredReviews = [];
    //     _fetchReviewsDataFuture = getVets();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Nombre...',
            suffixIcon: Icon(Icons.search),
            fillColor: Colors.blueAccent,

            iconColor: Colors.blueAccent,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent), // Cambia el color aquí
            ),
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: _fetchReviewsDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
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
                  'No hay calificaciones',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            if (_reviews == null ||  _filteredReviews.isEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'No hay calificaciones',
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
                    _loadMoreReviews();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: _filteredReviews.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _filteredReviews.length) {
                      if (_hasMore) {
                        return const Center(
                            child:
                            CircularProgressIndicator(color: Colors.blueAccent,));
                      } else {
                        return const Center(
                            child: Text(
                                'No se encontraron más calificaciones'
                                , style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 20)));
                      }
                    }
                    final review = _filteredReviews[index];
                    var conse = Random().nextInt(100);
                    review.client!.photo= 'https://picsum.photos/200/30$conse';
                    return Column(
                      children: [
                        _buildListItem(review),
                        const Divider(), // Divider entre cada revisión
                      ],
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildListItem(Review review) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: () => _navigateToReviewDetails(review),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  /*CircleAvatar(
                    foregroundColor: Colors.blue[100],
                    backgroundColor: Colors.blue[100],
                    backgroundImage: Image.network(review.client!.address).image,
                    radius: 30,
                  ),*/
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
                              review.client!.fullName,
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
                              review.client!.cityName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2.0),
                        /*Column(
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
                        ),*/
                        const SizedBox(height: 2.0),
                        Row(
                          children: [
                            const Icon(Icons.star_border_sharp),
                            const SizedBox(width: 8.0),
                            RatingBar.builder(
                              initialRating: review.rating,
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
