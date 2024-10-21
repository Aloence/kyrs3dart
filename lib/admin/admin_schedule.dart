import 'package:flutter/material.dart';
import 'package:schedule_app/admin/admin_schedule_edit.dart';

class Route {
  final String begin;
  final String destination;

  Route({required this.begin, required this.destination});
}

class Schedule {
  final String start;
  final String end;
  final int number;
  final int id;
  final Route route;

  Schedule({
    required this.start,
    required this.end,
    required this.number,
    required this.id,
    required this.route,
  });
}

class AdminScheduleScreen extends StatelessWidget {
  final List<Schedule> schedules = [
    Schedule(
      start: '08:00',
      end: '09:00',
      number: 1,
      id: 1,
      route: Route(begin: 'Остановка A', destination: 'Остановка B'),
    ),
    Schedule(
      start: '09:30',
      end: '10:30',
      number: 2,
      id: 2,
      route: Route(begin: 'Остановка C', destination: 'Остановка D'),
    ),
    Schedule(
      start: '11:00',
      end: '12:00',
      number: 3,
      id: 3,
      route: Route(begin: 'Остановка E', destination: 'Остановка F'),
    ),
    // Добавьте больше расписаний здесь
  ];

  void _editSchedule(context,int id) {
    // Логика для редактирования расписания
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewScheduleScreen(),
      ),
    );
    print('Редактирование расписания с id: $id');
  }

  void _deleteSchedule(int id) {
    // Логика для удаления расписания
    print('Удаление расписания с id: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание'),
      ),
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Номер: ${schedules[index].number}', // Номер расписания
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4), // Отступ между строками
                  Text(
                    '${schedules[index].route.begin} - ${schedules[index].route.destination}', // Начало и конец маршрута
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${schedules[index].start} - ${schedules[index].end}', // Начало и конец расписания
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // Уменьшаем размер Row
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteSchedule(schedules[index].id);
                    },
                    tooltip: 'Удалить',
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editSchedule(context,schedules[index].id);
                    },
                    tooltip: 'Редактировать',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}