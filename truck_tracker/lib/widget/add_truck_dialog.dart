import 'package:flutter/material.dart';
import '../model/truck_data.dart';

class AddTruckDialog extends StatefulWidget {
  final TruckData? truck;
  final Function(TruckData) onTruckAdded;

  const AddTruckDialog({
    super.key,
    this.truck,
    required this.onTruckAdded,
  });

  @override
  State<AddTruckDialog> createState() => _AddTruckDialogState();
}

class _AddTruckDialogState extends State<AddTruckDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _driverNameController;
  late TextEditingController _contactController;
  late TextEditingController _licenseController;
  late TextEditingController _truckNumberController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _departureController;
  late TextEditingController _arrivalController;
  late TextEditingController _areaController;
  late String _tripStatus;

  @override
  void initState() {
    super.initState();
    _driverNameController = TextEditingController(text: widget.truck?.driverName);
    _contactController = TextEditingController(text: widget.truck?.contact);
    _licenseController = TextEditingController(text: widget.truck?.license);
    _truckNumberController = TextEditingController(text: widget.truck?.truckNumber);
    _vehicleTypeController = TextEditingController(text: widget.truck?.vehicleType);
    _departureController = TextEditingController(text: widget.truck?.departure);
    _arrivalController = TextEditingController(text: widget.truck?.arrival);
    _areaController = TextEditingController(text: widget.truck?.area);
    if (widget.truck != null) {
      _tripStatus = widget.truck!.tripStatus;
    }
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _contactController.dispose();
    _licenseController.dispose();
    _truckNumberController.dispose();
    _vehicleTypeController.dispose();
    _departureController.dispose();
    _arrivalController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final truck = TruckData(
        id: widget.truck?.id ?? DateTime.now().toString(),
        driverName: _driverNameController.text,
        driverImage: 'assets/images/user_pic.jpg',
        contact: _contactController.text,
        license: _licenseController.text,
        truckNumber: _truckNumberController.text,
        vehicleType: _vehicleTypeController.text,
        departure: _departureController.text,
        arrival: _arrivalController.text.isEmpty ? "null" : _arrivalController.text,
        area: _areaController.text,
        tripStatus: _arrivalController.text.isEmpty ? 'In Progress' : 'Completed',
      );
      widget.onTruckAdded(truck);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TRUCK DETAILS',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _driverNameController,
                  decoration: const InputDecoration(
                    labelText: 'Trucker Name',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter trucker name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _licenseController,
                  decoration: const InputDecoration(
                    labelText: 'License',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter license number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _truckNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Truck',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter truck number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _vehicleTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Type',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter vehicle type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _departureController,
                  decoration: const InputDecoration(
                    labelText: 'Departure',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  readOnly: true,
                  onTap: () => _selectTime(context, _departureController),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter departure time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _arrivalController,
                  decoration: const InputDecoration(
                    labelText: 'Arrival',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  readOnly: true,
                  onTap: () => _selectTime(context, _arrivalController),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter area';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _tripStatus,
                  decoration: const InputDecoration(
                    labelText: 'Trip Status',
                  ),
                  items: ['In Progress', 'Completed', 'Delayed', 'Cancelled']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _tripStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('DONE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}