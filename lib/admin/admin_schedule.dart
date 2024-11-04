import 'package:flutter/material.dart';
import 'package:schedule_app/admin/admin_schedule_edit.dart';
import 'package:schedule_app/graph_ql_services/graph_sched_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';


class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleListScreen>
    with SingleTickerProviderStateMixin {
  final ScheduleGraphQLService _graphQLService = ScheduleGraphQLService();

  List<ScheduleModel>? _schedules;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _schedules = null;
    List<ScheduleModel> schedules = await _graphQLService.getSchedules();
    setState(() => _schedules = schedules);
  }

  void _editSchedule(int id) {
    // // Логика для редактирования расписания
     Navigator.push(
      context,
      MaterialPageRoute(  
        builder: (context) => NewScheduleScreen(id: id),
      ),
    );
    print('Редактирование расписания с id: $id');
  }

  void _addSchedule(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewScheduleScreen(),
      ),
    );
  }

  void _deleteSchedule(int id) {
    // // Логика для удаления расписания
    // print('Удаление расписания с id: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание'),
      ),
      body: Column(
        children: [
          Expanded(child:ListView.builder(
            itemCount: _schedules!.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        '${_schedules![index].name}', // Начало и конец расписания
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${_schedules![index].start} - ${_schedules![index].end}', // Начало и конец расписания
                        style: TextStyle(fontSize: 16),
                      ), 
                      Text(
                        '${_schedules![index].route.name} | ${_schedules![index].route.start.name} - ${_schedules![index].route.end.name}', // Начало и конец маршрута
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
                          // _deleteSchedule(schedules[index].id);
                        },
                        tooltip: 'Удалить',
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editSchedule(_schedules![index].id);
                        },
                        tooltip: 'Редактировать',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addSchedule, 
              child: Text('Добавить Маршрут'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
              ),
            ),
          ),
        ],
      )
      
      
    );
  }
}