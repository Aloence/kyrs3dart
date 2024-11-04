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
            _buildButton(context, 'Остановки',  StopListScreen()),
            _buildButton(context, 'Маршруты', RouteListScreen()),
            _buildButton(context, 'Расписания', ScheduleListScreen()),
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

// Экран для Маршрутов
class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CRUDScreen(title: 'Маршруты');
  }
}

// Экран для Расписаний
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CRUDScreen(title: 'Расписания');
  }
}

// Экран для Автобусов
class BusesScreen extends StatelessWidget {
  const BusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CRUDScreen(title: 'Автобусы');
  }
}

// Общий экран для CRUD операций
class CRUDScreen extends StatelessWidget {
  final String title;

  const CRUDScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CRUD операции для $title', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            _buildCRUDButton(context, 'Создать'),
            _buildCRUDButton(context, 'Читать'),
            _buildCRUDButton(context, 'Обновить'),
            _buildCRUDButton(context, 'Удалить'),
          ],
        ),
      ),
    );
  }


  Widget _buildCRUDButton(BuildContext context, String action) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$action $title')),
        );
      },
      child: Text(action, style: const TextStyle(fontSize: 18)),
    );
  }
}