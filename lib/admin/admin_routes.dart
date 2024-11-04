import 'package:flutter/material.dart';
import 'package:schedule_app/admin/admin_route_edit.dart';
import 'package:schedule_app/graph_ql_services/graph_route_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';



class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListState();
}

class _RouteListState extends State<RouteListScreen>
    with SingleTickerProviderStateMixin {
  
  
  final RouteGraphQLService _graphQLService = RouteGraphQLService();
  
  List<RouteModel>? _routes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _routes = null;
    List<RouteModel> routes = await _graphQLService.getRoutes();
    setState(() => _routes = routes);
  }

  void _addRoute(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewRouteScreen(),
      ),
    );
  }
  void _editRoute(context,int id) {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewRouteScreen(id: id),
      ),
    );
    // Логика для редактирования маршрута
    print('Редактирование маршрута с id: $id');
  }

  void _deleteRoute(int id) {
    // Логика для удаления маршрута
    print('Удаление маршрута с id: $id');
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Маршрутов'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _routes!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Маршрут ${_routes![index].name}', // Название маршрута
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4), // Отступ между строками
                        Text(
                          ' ${_routes![index].start.name} - ${_routes![index].end.name}', // Начало маршрута
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
                            // _deleteRoute(_routes[index].id);
                          },
                          tooltip: 'Удалить',
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
            
                            _editRoute(context,_routes![index].id);
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
          // Кнопка внизу экрана
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addRoute, // Логика для добавления нового маршрута
              child: Text('Добавить Маршрут'),
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
