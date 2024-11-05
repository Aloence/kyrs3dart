import 'package:flutter/material.dart';
import 'package:schedule_app/admin/edit/admin_bus_edit.dart';
import 'package:schedule_app/graph_ql_services/graph_bus_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';



class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListState();
}

class _BusListState extends State<BusListScreen>
    with SingleTickerProviderStateMixin {
  
  
  final BusGraphQLService _graphQLService = BusGraphQLService();
  List<BusModel>? _buses;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadBuses();
  }

  Future<void> _loadBuses() async {
    _buses = null;
    List<BusModel> buses = await _graphQLService.getBuses();
    setState(() => _buses = buses);
  }
  void _editBus(int busId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusEditScreen(busId:busId),
      ),
    );
    // Логика для редактирования автобуса
    print('Редактирование автобуса с id: $busId');
  }

  void _addBus(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusEditScreen(),
      ),
    );
  }
  void _deleteBus(int id) {
   
    print('Удаление автобуса с id: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Автобусы'),
      ),
      body:Column(
        children: [
          Expanded(
            child:ListView.builder(
            itemCount: _buses!.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Автобус №${_buses![index].name}', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${_buses![index].schedule.route!.start!.name} - ${_buses![index].schedule.route!.end!.name}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Расписание: №${_buses![index].schedule.name},'
                        + '${_buses![index].schedule.start} - ${_buses![index].schedule.end}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Цена: ${_buses![index].price} руб.',
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
                          // _deleteBus(_buses[index].id);
                        },
                        tooltip: 'Удалить',
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editBus(_buses![index].id);
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
            onPressed: _addBus, 
            child: Text('Добавить Автобус'),
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