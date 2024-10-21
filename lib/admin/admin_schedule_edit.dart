import 'package:flutter/material.dart';

class Stop {
  final int id;
  final String name;

  Stop({required this.id, required this.name});
}

class Route {
  final int id;
  final String start;
  final String end;
  final List<Stop> stops;

  Route({required this.id, required this.start, required this.end, required this.stops});
}

class NewScheduleScreen extends StatefulWidget {
  @override
  _RouteSelectionScreenState createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<NewScheduleScreen> {
  List<Route> routes = [
    Route(
      id: 1,
      start: 'Остановка A',
      end: 'Остановка B',
      stops: [
        Stop(id: 1, name: 'Остановка 1'),
        Stop(id: 2, name: 'Остановка 2'),
        Stop(id: 3, name: 'Остановка 3'),
      ],
    ),
    Route(
      id: 2,
      start: 'Остановка C',
      end: 'Остановка D',
      stops: [
        Stop(id: 4, name: 'Остановка 4'),
        Stop(id: 5, name: 'Остановка 5'),
        Stop(id: 6, name: 'Остановка 6'),
        Stop(id: 7, name: 'Остановка 6'),
      ],
    ),
  ];

  Route? selectedRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите Маршрут'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Route>(
              hint: Text('Выберите маршрут'),
              value: selectedRoute,
              onChanged: (Route? newValue) {
                setState(() {
                  selectedRoute = newValue;
                });
              },
              items: routes.map((Route route) {
                return DropdownMenuItem<Route>(
                  value: route,
                  child: Text('${route.start} - ${route.end}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (selectedRoute != null) ...[
              Text(
                'Остановки для маршрута ${selectedRoute!.start} - ${selectedRoute!.end}:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedRoute!.stops.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedRoute!.stops[index].name),
                          Container(
                            width: 100, // Фиксированная ширина для поля ввода
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Введите текст',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
               SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Время начала',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // startTime = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Время конца',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // endTime = value;
                },
              ),

            ],
          ],
        ),
      ),
    );
  }
}