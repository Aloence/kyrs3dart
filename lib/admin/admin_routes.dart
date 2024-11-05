import 'package:flutter/material.dart';
import 'package:schedule_app/admin/edit/admin_route_edit.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_route_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';



class AdminRoutesList extends StatefulWidget {
  const AdminRoutesList({super.key});

  @override
  State<AdminRoutesList> createState() => _RoutesListState();
}

class _RoutesListState extends State<AdminRoutesList>
    with SingleTickerProviderStateMixin {

  final GraphQLService _graphQLService = GraphQLService();
  
  List<RouteModel>? _routes;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    _routes = null;
    List<RouteModel> routes = await _graphQLService.getRoutes();
    setState(() => _routes = routes);
  }

  void _addRoute(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteEditScreen(),
      ),
    );
  }
  void _editRoute(int routeId) {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteEditScreen(routeId: routeId),
      ),
    );
  }

  void _deleteRoute(int id) {
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
                          'Маршрут ${_routes![index].name}', 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4), 
                        Text(
                          ' ${_routes![index].start!.name} - ${_routes![index].end!.name}', 
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
                            // _deleteRoute(_routes[index].id);
                          },
                          tooltip: 'Удалить',
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _editRoute(_routes![index].id!);
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
              onPressed: _addRoute,
              child: Text('Добавить Маршрут'),
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
