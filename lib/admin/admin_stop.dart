import 'package:flutter/material.dart';
import 'package:schedule_app/admin/admin_stop_edit.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';
import 'package:schedule_app/graph_ql_services/graphql_st_service.dart';



class StopListScreen extends StatefulWidget {
  const StopListScreen({super.key});

  @override
  State<StopListScreen> createState() => _StopListState();
}

class _StopListState extends State<StopListScreen>
    with SingleTickerProviderStateMixin {
  
  final StopGraphQLService _graphQLService = StopGraphQLService();
  
  List<StopModel>? _stops;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _stops = null;
    List<StopModel> stops = await _graphQLService.getStops();
    setState(() => _stops = stops);
  }

  void _addStop(context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StopEditScreen(stop:null),
      ),
    );
  }
  void _editStop(context,StopModel stop) {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StopEditScreen(stop:stop),
      ),
    );
  }
  void _deleteStop(int id) {
    // Логика для удаления остановки
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
                          _editStop(context,_stops![index]);
                        },
                        tooltip: 'Редактировать',
                      ),
                      
                    ],
                  ),
                );
              },
            ),
          ),
          // Кнопка внизу экрана
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Логика для добавления новой остановки
                _addStop(context);
                print('Добавление новой остановки');
              },
              child: Text('Добавить Остановку'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
              ),
            ),
          ),
        ],
      ),
    );
  }
}

