import 'package:flutter/material.dart';
import '../model/truck_data.dart';

class AdminTruckCard extends StatelessWidget {
  final TruckData truck;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  const AdminTruckCard({
    super.key,
    required this.truck,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF00FF41),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Column 1: Image
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(truck.driverImage),
            ),
            const SizedBox(width: 16),

            // Column 2: Driver and Truck
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: 'Driver: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: truck.driverName),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: 'Truck: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: truck.truckNumber),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Column 3: Departure and Arrival
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: 'Departure: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: truck.departure),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: 'Arrival: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: truck.arrival ?? "...."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}