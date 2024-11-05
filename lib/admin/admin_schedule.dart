import 'package:flutter/material.dart';
import 'package:schedule_app/admin/edit/admin_schedule_edit.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';


class AdminSchedulesList extends StatefulWidget {
  const AdminSchedulesList({super.key});

  @override
  _SchedulesListState createState() => _SchedulesListState();
}

class _SchedulesListState extends State<AdminSchedulesList>
  with SingleTickerProviderStateMixin{
    
  final GraphQLService _graphQLService = GraphQLService();

  List<ScheduleModel>? _schedules;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    _schedules = null;
    List<ScheduleModel> schedules = await _graphQLService.getSchedules();
    setState(() => _schedules = schedules);
  }

  void _editSchedule(int scheduleId) {
     Navigator.push(
      context,
      MaterialPageRoute(  
        builder: (context) => ScheduleEditScreen(scheduleId: scheduleId),
      ),
    );
  }

  void _addSchedule(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleEditScreen(),
      ),
    );
  }

  void _deleteSchedule(int id) {
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
                        '${_schedules![index].name}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${_schedules![index].start} - ${_schedules![index].end}', 
                        style: TextStyle(fontSize: 16),
                      ), 
                      Text(
                        '${_schedules![index].route!.name} |'
                        +'${_schedules![index].route!.start!.name} - ${_schedules![index].route!.end!.name}', 
                        style: TextStyle(fontSize: 16),
                      ),
                      
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, 
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
                          _editSchedule(_schedules![index].id!);
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
                minimumSize: Size(double.infinity, 50), 
              ),
            ),
          ),
        ],
      )
      
      
    );
  }
}