import 'package:flutter/material.dart';
import 'package:truck_tracker/model/truck_data.dart';
import 'package:truck_tracker/utils/truck_services.dart';
import 'package:truck_tracker/widget/add_truck_dialog.dart';
import 'package:truck_tracker/widget/truck_card.dart';

class ReceptionistScreen extends StatefulWidget {
  const ReceptionistScreen({super.key});

  @override
  State<ReceptionistScreen> createState() => _ReceptionistScreenState();
}

class _ReceptionistScreenState extends State<ReceptionistScreen> {
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

  void _showAddTruckDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTruckDialog(
        onTruckAdded: (truck) async {
          await _dataService.addTruck(truck);
          _loadTrucks();
        },
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: const Text('Truck Tracker - Receptionist'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _handleSearch,
                    decoration: InputDecoration(
                      hintText: 'Search ${_searchType == SearchType.driverName ? 'Driver' : 'Truck'}',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<SearchType>(
                  value: _searchType,
                  onChanged: (SearchType? value) {
                    if (value != null) {
                      setState(() {
                        _searchType = value;
                      });
                      _applyFilters();
                    }
                  },
                  items: SearchType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16),
                DropdownButton<SortCriteria>(
                  value: _sortCriteria,
                  onChanged: (SortCriteria? value) {
                    if (value != null) {
                      setState(() {
                        _sortCriteria = value;
                      });
                      _applyFilters();
                    }
                  },
                  items: SortCriteria.values.map((criteria) {
                    return DropdownMenuItem(
                      value: criteria,
                      child: Text('Sort by ${criteria.toString().split('.').last}'),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16),
                FilterChip(
                  label: const Text('Arrived Only'),
                  selected: _filterArrived,
                  onSelected: (bool value) {
                    setState(() {
                      _filterArrived = value;
                    });
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400, // Maximum width of each card
                mainAxisExtent: 400,    // Approximate height, adjust if needed
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _trucks.length,
              itemBuilder: (context, index) {
                return TruckCard(
                  truck: _trucks[index],
                  onDelete: () async {
                    await _dataService.deleteTruck(_trucks[index].id);
                    _loadTrucks();
                  },
                  onEdit: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddTruckDialog(
                        truck: _trucks[index],
                        onTruckAdded: (truck) async {
                          await _dataService.updateTruck(truck);
                          _loadTrucks();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTruckDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}