import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/truck_data.dart';

class TruckDataService {
  static const String fileName = 'truck_tracker.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<List<TruckData>> searchTrucks(String query, SearchType searchType) async {
    final trucks = await getAllTrucks();
    return trucks.where((truck) {
      switch (searchType) {
        case SearchType.driverName:
          return truck.driverName.toLowerCase().contains(query.toLowerCase());
        case SearchType.truckNumber:
          return truck.truckNumber.toLowerCase().contains(query.toLowerCase());
        default:
          return false;
      }
    }).toList();
  }

  Future<List<TruckData>> sortTrucks(List<TruckData> trucks, SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.departure:
        trucks.sort((a, b) => a.departure.compareTo(b.departure));
        break;
      case SortCriteria.arrival:
        trucks.sort((a, b) {
          if (a.arrival.isEmpty && b.arrival.isEmpty) return 0;
          if (a.arrival.isEmpty) return 1;
          if (b.arrival.isEmpty) return -1;
          return a.arrival.compareTo(b.arrival);
        });
        break;
      case SortCriteria.driverName:
        trucks.sort((a, b) => a.driverName.compareTo(b.driverName));
        break;
    }
    return Future.value(trucks);
  }

  Future<void> initializeData() async {
    final file = await _localFile;
    if (!await file.exists()) {
      final initialData = [
        TruckData(
          id: '1',
          driverName: 'John Smith',
          driverImage: 'assets/images/user_pic.jpg',
          contact: '0723 456 789',
          license: 'DL789012',
          truckNumber: 'KXA 789H',
          vehicleType: 'Container',
          departure: '08:30 AM',
          arrival: 'Pending',
          area: 'Manhattan',
          tripStatus: 'In Progress',
        ),
        TruckData(
          id: '2',
          driverName: 'Sarah Wilson',
          driverImage: 'assets/images/user_pic.jpg',
          contact: '0734 567 890',
          license: 'DL456789',
          truckNumber: 'KBZ 234J',
          vehicleType: 'Tanker',
          departure: '09:15 AM',
          arrival: 'Pending',
          area: 'Brooklyn',
          tripStatus: 'In Progress',
        ),
        // Add more sample data here
      ];

      await file.writeAsString(jsonEncode(initialData.map((e) => e.toJson()).toList()));
    }
  }

  Future<List<TruckData>> getAllTrucks() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => TruckData.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addTruck(TruckData truck) async {
    final trucks = await getAllTrucks();
    trucks.add(truck);
    final file = await _localFile;
    await file.writeAsString(jsonEncode(trucks.map((e) => e.toJson()).toList()));
  }

  Future<void> updateTruck(TruckData updatedTruck) async {
    final trucks = await getAllTrucks();
    final index = trucks.indexWhere((truck) => truck.id == updatedTruck.id);
    if (index != -1) {
      trucks[index] = updatedTruck;
      final file = await _localFile;
      await file.writeAsString(jsonEncode(trucks.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> deleteTruck(String id) async {
    final trucks = await getAllTrucks();
    trucks.removeWhere((truck) => truck.id == id);
    final file = await _localFile;
    await file.writeAsString(jsonEncode(trucks.map((e) => e.toJson()).toList()));
  }

  Future<List<TruckData>> filterTrucks(String criteria, String value) async {
    final trucks = await getAllTrucks();
    return trucks.where((truck) {
      switch (criteria.toLowerCase()) {
        case 'arrival':
          return truck.arrival.toLowerCase().contains(value.toLowerCase());
        case 'area':
          return truck.area.toLowerCase().contains(value.toLowerCase());
        case 'status':
          return truck.tripStatus.toLowerCase().contains(value.toLowerCase());
        default:
          return true;
      }
    }).toList();
  }
}