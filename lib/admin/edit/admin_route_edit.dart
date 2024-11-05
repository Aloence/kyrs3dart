import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';

class RouteEditScreen extends StatefulWidget {
  int? routeId ;
  RouteEditScreen({this.routeId});
  @override 
  _RouteEditScreenState createState() => _RouteEditScreenState();
}

class _RouteEditScreenState extends State<RouteEditScreen> {
  
  final GraphQLService _graphQLService = GraphQLService();

  List<StopModel>? _availableStops;  
  List<StopModel> _stops = [];

  final TextEditingController _nameController = TextEditingController();
  
  @override
  void initState() { 
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadStops();
    if (widget.routeId != null) {
      await _loadRoute(widget.routeId!); 
    }
  }
  Future<void> _loadRoute(int routeId) async{
    RouteModel route = await _graphQLService.getRouteById(routeId:routeId);
    _nameController.text = route.name ?? '';
    setState(() {
      _stops = route.stops ?? [];
    });
   
    
    
  }
  Future<void> _loadStops() async {
    _availableStops = null;
    List<StopModel> availableStops = await _graphQLService.getStops();
    setState(() => _availableStops = availableStops);
  }

  RouteInput _getRouteInput(){
    List<int> stopIds = _stops.map((stop) => stop.id).toList();
    return RouteInput(name: _nameController.text, stopIds: stopIds);
  }

  Future<void> _createRoute() async{
    RouteInput routeInput = _getRouteInput();
    await _graphQLService.createRoute(routeInput: routeInput);
  }

  void editRoute(){
  }
  void deleteRoute(){
  }


  void _addStop(StopModel stop) {
    setState(() {
      _stops.add(stop);
    });
    Navigator.of(context).pop(); // Закрываем список остановок после выбора
  }

  void _removeStop(StopModel stop) {
    setState(() {
      _stops.remove(stop);
    });
  }

  void _showStopSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _availableStops!.length,
          itemBuilder: (context, index) {
            if (_stops.contains(_availableStops![index])) {
              return Container(); 
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Маршрут Остановок'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController, 
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
                    key: ValueKey(_stops[index].id),
                    title: Text(_stops[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeStop(_stops[index]),
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--; 
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
                minimumSize: Size(double.infinity, 50), 
              ),
            ),
            ElevatedButton(
              onPressed: _createRoute,
              child: Text('Сохранить Маршрут'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}