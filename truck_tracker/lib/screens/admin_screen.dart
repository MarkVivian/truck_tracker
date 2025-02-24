import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../model/truck_data.dart';
import '../utils/truck_services.dart';
import '../widget/admin_truck_card.dart';
import '../widget/truck_card.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TruckDataService _dataService = TruckDataService();
  List<TruckData> _trucks = [];
  SearchType _searchType = SearchType.driverName;
  String _searchQuery = '';
  SortCriteria _sortCriteria = SortCriteria.departure;
  bool _filterArrived = false;

  @override
  void initState() {
    super.initState();
    _loadTrucks();
  }

  Future<void> _loadTrucks() async {
    final trucks = await _dataService.getAllTrucks();
    setState(() {
      _trucks = trucks;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _applyFilters() async {
    var filteredTrucks = await _dataService.getAllTrucks();

    if (_searchQuery.isNotEmpty) {
      filteredTrucks = await _dataService.searchTrucks(_searchQuery, _searchType);
    }

    if (_filterArrived) {
      filteredTrucks = filteredTrucks.where((truck) => truck.arrival.isNotEmpty).toList();
    }

    filteredTrucks = await _dataService.sortTrucks(filteredTrucks, _sortCriteria);

    setState(() {
      _trucks = filteredTrucks;
    });
  }

  void _showTruckDetails(TruckData truck) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: TruckCard(
          truck: truck,
          isAdminView: true, // This will hide the DELETE INFO and EDIT INFO buttons
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Map Section (increased size)
          Expanded(
            flex: 2,
            child: FlutterMap(
              options: MapOptions(
                center: const LatLng(1.2921, 36.8219), // Nairobi, Kenya coordinates
                zoom: 6.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _trucks
                      .where((truck) => truck.latitude != null && truck.longitude != null)
                      .map((truck) => Marker(
                    point: LatLng(truck.latitude!, truck.longitude!),
                    builder: (ctx) => GestureDetector(
                      onTap: () => _showTruckDetails(truck),
                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          // Truck Details Section (decreased size)
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF008C45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Truck Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: _handleSearch,
                      decoration: InputDecoration(
                        hintText: 'Search Truck/Driver',
                        filled: true,
                        fillColor: const Color(0xFF90EE90),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text('Filter: ', style: TextStyle(color: Colors.white)),
                        DropdownButton<bool>(
                          value: _filterArrived,
                          dropdownColor: const Color(0xFF90EE90),
                          items: const [
                            DropdownMenuItem(value: false, child: Text('All')),
                            DropdownMenuItem(value: true, child: Text('Arrived')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _filterArrived = value ?? false;
                            });
                            _applyFilters();
                          },
                        ),
                        const Spacer(),
                        const Text('Sort By: ', style: TextStyle(color: Colors.white)),
                        DropdownButton<SortCriteria>(
                          value: _sortCriteria,
                          dropdownColor: const Color(0xFF90EE90),
                          items: SortCriteria.values
                              .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.toString().split('.').last),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _sortCriteria = value;
                              });
                              _applyFilters();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _trucks.length,
                      itemBuilder: (context, index) {
                        return AdminTruckCard(
                          truck: _trucks[index],
                          onTap: () {
                            print('Truck ${_trucks[index].truckNumber} clicked');
                          },
                          onDoubleTap: () => _showTruckDetails(_trucks[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}