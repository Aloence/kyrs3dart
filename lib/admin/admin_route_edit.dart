import 'package:flutter/material.dart';



class Stop {
  final int id;
  final String name;

  Stop({required this.id, required this.name});
}

class Route {
  final int id;
  List<Stop> stops;

  Route({required this.id, required this.stops});
}

class NewRouteScreen extends StatefulWidget {
  @override
  _NewRouteScreenState createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends State<NewRouteScreen> {
  List<Stop> availableStops = [
    Stop(id: 1, name: 'Остановка A'),
    Stop(id: 2, name: 'Остановка B'),
    Stop(id: 3, name: 'Остановка C'),
  ];

  Route route = Route(id: 1, stops: []);

  void _addStop(Stop stop) {
    setState(() {
      route.stops.add(stop);
    });
    Navigator.of(context).pop(); // Закрываем список остановок после выбора
  }

  void _removeStop(Stop stop) {
    setState(() {
      route.stops.remove(stop);
    });
  }

  void _showStopSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: availableStops.length,
          itemBuilder: (context, index) {
            // Проверяем, добавлена ли остановка в маршрут
            if (route.stops.contains(availableStops[index])) {
              return Container(); // Если остановка уже добавлена, не отображаем её
            }
            return ListTile(
              title: Text(availableStops[index].name),
              onTap: () => _addStop(availableStops[index]),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Маршрут Остановок'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Маршрут ID: ${route.id}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Остановки:',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: route.stops.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: ValueKey(route.stops[index].id), // Уникальный ключ
                    title: Text(route.stops[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeStop(route.stops[index]),
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--; // Корректируем индекс
                    final Stop movedStop = route.stops.removeAt(oldIndex);
                    route.stops.insert(newIndex, movedStop);
                  });
                  // for(var i =0;i<route.stops.length;i++){
                  //   print(route.stops[i].name);
                  // }
                },
              ),
            ),
            ElevatedButton(
              onPressed: _showStopSelection,
              child: Text('Добавить Остановку'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
              ),
            ),
            ElevatedButton(
              onPressed: (){},
              child: Text('Сохранить Остановку'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
              ),
            ),
          ],
        ),
      ),
    );
  }
}