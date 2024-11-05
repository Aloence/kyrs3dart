import 'package:flutter/material.dart';
import 'package:schedule_app/admin/admin_buses.dart';
import 'package:schedule_app/admin/admin_routes.dart';
import 'package:schedule_app/admin/admin_schedule.dart';
import 'package:schedule_app/admin/admin_stop.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: [
            _buildButton(context, 'Остановки',  AdminStopsList()),
            _buildButton(context, 'Маршруты', AdminRoutesList()),
            _buildButton(context, 'Расписания', AdminSchedulesList()),
            _buildButton(context, 'Автобусы', BusListScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget nextScreen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
      child: Text(title, style: const TextStyle(fontSize: 18)),
    );
  }
}