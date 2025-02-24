import 'package:flutter/material.dart';
import '../model/truck_data.dart';

class TruckCard extends StatelessWidget {
  final TruckData truck;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;
  final bool isAdminView;

  const TruckCard({
    super.key,
    required this.truck,
    this.onDelete,
    this.onEdit,
    this.onTap,
    this.isAdminView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, // Fixed width for consistent shape
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Truck Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(truck.driverImage),
          ),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoColumn([
                    _buildInfoText('Driver', truck.driverName),
                    _buildInfoText('Contact', truck.contact),
                    _buildInfoText('License', truck.license),
                    _buildInfoText('Truck', truck.truckNumber),
                    _buildInfoText('Vehicle Type', truck.vehicleType),
                  ]),
                ),
                const SizedBox(width: 6), // Space between columns
                Expanded(
                  child: _buildInfoColumn([
                    _buildInfoText('Departure', truck.departure),
                    _buildInfoText('Arrival', truck.arrival.isEmpty ? "......" : truck.arrival),
                    _buildInfoText('Area', truck.area),
                    _buildInfoText('Trip Status', truck.tripStatus),
                  ]),
                ),
              ],
            ),
          ),
          if (!isAdminView)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('DELETE INFO', onDelete),
                  _buildButton('EDIT INFO', onEdit),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback? onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF008C45).withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}