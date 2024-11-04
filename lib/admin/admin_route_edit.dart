import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_services/graph_route_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';
import 'package:schedule_app/graph_ql_services/graphql_st_service.dart';

class NewRouteScreen extends StatefulWidget {
  int? id ;
  NewRouteScreen({this.id});
  @override 
  _NewRouteScreenState createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends State<NewRouteScreen> {
  // #kost
  final RouteGraphQLService _graphQLService = RouteGraphQLService();
  final StopGraphQLService _stopGraphQLService = StopGraphQLService();

  List<StopModel>? _availableStops;  
  List<StopModel> _stops = [];
  final TextEditingController _nameController = TextEditingController();

  void _loadRoute(int id) async{
    RouteModel route = await _graphQLService.getRouteById(id:id);
    _nameController.text = route.name ?? '';
    _stops = route.stops ?? [];
    
  }
  void _loadStops() async {
    _availableStops = null;
    List<StopModel> availableStops = await _stopGraphQLService.getStops();
    setState(() => _availableStops = availableStops);
  }

  RouteInput _toRouteInput(){
    List<int> stopIds = _stops.map((stop) => stop.id).toList();
    return RouteInput(name: _nameController.text, stopIds: stopIds);
  }
  void _createRoute() async{
    RouteInput routeInput = _toRouteInput();
    await _graphQLService.createRoute(routeInput: routeInput);
  }

  void editRoute(){
  }
  void deleteRoute(){
  }


  @override
  void initState() {
    // #mb awaits here?
    super.initState();
    _loadStops();
    if (widget.id != null) {
      _loadRoute(widget.id!); 
    }
  }
  // route = RouteModel(id: id, start: start, end: end);
  void _addStop(StopModel stop) {
    setState(() {
      _stops.add(stop);
      // _stops.add(stop);
    });
    Navigator.of(context).pop(); // Закрываем список остановок после выбора
  }

  void _removeStop(StopModel stop) {
    setState(() {
      _stops.remove(stop);
      // _stops.remove(stop);
    });
  }

  void _showStopSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _availableStops!.length,
          itemBuilder: (context, index) {
            // Проверяем, добавлена ли остановка в маршрут
            if (_stops.contains(_availableStops![index])) {
              return Container(); // Если остановка уже добавлена, не отображаем её
            }
            return ListTile(
              title: Text(_availableStops![index].name),
              onTap: () => _addStop(_availableStops![index]),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    
    // _nameController.text = route?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Маршрут Остановок'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController, // Привязка контроллера к текстовому полю
              decoration: InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Остановки:',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _stops.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: ValueKey(_stops[index].id), // Уникальный ключ
                    title: Text(_stops[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeStop(_stops[index]),
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--; // Корректируем индекс
                    final StopModel movedStop = _stops.removeAt(oldIndex);
                    _stops.insert(newIndex, movedStop);
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
              onPressed: _createRoute,
              child: Text('Сохранить Маршрут'),
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