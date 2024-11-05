import 'package:flutter/material.dart';
import 'package:schedule_app/admin/edit/admin_stop_edit.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';



class AdminStopsList extends StatefulWidget {
  const AdminStopsList({super.key});

  @override
  State<AdminStopsList> createState() => _StopsListState();
}

class _StopsListState extends State<AdminStopsList>
    with SingleTickerProviderStateMixin {
  
  final GraphQLService _graphQLService = GraphQLService();
  
  List<StopModel>? _stops;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadStops();
  }

  Future<void> _loadStops() async {
    _stops = null;
    List<StopModel> stops = await _graphQLService.getStops();
    setState(() => _stops = stops);
  }

  void _createStop(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StopEditScreen(),
      ),
    );
  }
  
  void _editStop(StopModel stop) {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StopEditScreen(stopId: stop.id),
      ),
    );
  }
  
  void _deleteStop(int id) {
    print('Удаление остановки с id: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Остановок'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _stops!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _stops![index].name,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteStop(_stops![index].id);
                        },
                        tooltip: 'Удалить',
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editStop(_stops![index]);
                        },
                        tooltip: 'Редактировать',
                      ),
                      
                    ],
                  ),
                );
              },
            ),
          ),
         
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
           
                _createStop();
                print('Добавление новой остановки');
              },
              child: Text('Добавить Остановку'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}

