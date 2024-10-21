import 'package:flutter/material.dart';
import 'package:schedule_app/admin/admin_route_edit.dart';


class Route {
  final int id;
  final String start;
  final String end;

  Route({required this.id, required this.start, required this.end});
}

class RouteListScreen extends StatelessWidget {
  final List<Route> routes = [
    Route(id: 1, start: 'Остановка A', end: 'Остановка B'),
    Route(id: 2, start: 'Остановка C', end: 'Остановка D'),
    Route(id: 3, start: 'Остановка E', end: 'Остановка F'),
    // Добавьте больше маршрутов здесь
  ];

  void _addRoute(){

  }
  void _editRoute(context,int id) {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewRouteScreen(),
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
              itemCount: routes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Маршрут ${routes[index].id}', // Название маршрута
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4), // Отступ между строками
                        Text(
                          ' ${routes[index].start} - ${routes[index].end}', // Начало маршрута
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
                            _deleteRoute(routes[index].id);
                          },
                          tooltip: 'Удалить',
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
            
                            _editRoute(context,routes[index].id);
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
