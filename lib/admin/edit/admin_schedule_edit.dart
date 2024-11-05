import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';


class ScheduleStopView {
  final String time;
  final StopModel stop;

  ScheduleStopView({
    required this.time,
    required this.stop,
  });
}

class ScheduleEditScreen extends StatefulWidget {
  int? scheduleId;
  ScheduleEditScreen({this.scheduleId});

  @override
  _ScheduleEditScreenState createState() => _ScheduleEditScreenState();
}

class _ScheduleEditScreenState extends State<ScheduleEditScreen> 
  with SingleTickerProviderStateMixin{
  
  final GraphQLService _graphQLService = GraphQLService();

  List<RouteModel> _availableRoutes=[]; 
  RouteModel? _selectedRoute;
  List<ScheduleStopView>  _schedule = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  List<TextEditingController> _controllers = [];
  

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadRoutes();
    if (widget.scheduleId != null) {
      await _loadSchedule(widget.scheduleId!);
    }
  }

  Future<void> _loadSchedule(int scheduleId) async{
    ScheduleModel schedule = await _graphQLService.getScheduleById(scheduleId: scheduleId);
    
    _nameController.text =schedule.name!;
    _startController.text = schedule.start!;
    _endController.text = schedule.end!;

    // #kost или нет ?
    List<RouteModel> filteredRoutes = _availableRoutes.where(
        (route) => route.id == schedule.route!.id!).toList();

    _setSelectedRoute(filteredRoutes[0]);
    _setScheduleFromSchedule(schedule);

  }
 
  void _setSelectedRoute(RouteModel route){
    setState(() {
      _selectedRoute = route;
    });
  }
  // #kost название 
  void _setScheduleFromSchedule(ScheduleModel schedule){
    setState(() {
        _schedule = schedule.schedule!.map((stop) {
          return ScheduleStopView(time: stop.time, stop: stop.stop);
        }).toList();
    });

    _controllers = List.generate(_schedule.length, (index) => TextEditingController(text: _schedule[index].time));
  }
  
  void _setScheduleFromStops(List<StopModel> stops){
      setState(() {
        _schedule = stops.map((stop) {
          return ScheduleStopView(time: '', stop: stop);
        }).toList();
      });
      // print('setterstop');
      // for (var s in _schedule) {
      //   print(s);
      // }
      _controllers = List.generate(_schedule.length, (index) => TextEditingController(text: _schedule[index].time));
  }

  Future<void> _loadRoute(RouteModel route) async{
    // тут еще можно проверить грузился ли он до этого
    RouteModel new_route = await _graphQLService.getRouteById(routeId:route.id!);

    _setSelectedRoute(route);
    _setScheduleFromStops(new_route.stops!);
  }
      
  Future<void> _loadRoutes() async {
    _availableRoutes = [];
    List<RouteModel> availableRoutes = await _graphQLService.getRoutes();
    setState(() => _availableRoutes = availableRoutes);
  }
  
  ScheduleInput _getScheduleInput(){
    List<ScheduleStopInput> scheduleInput = [];
    for (int i = 0; i < _schedule.length; i++) {
      ScheduleStopInput new_stop = ScheduleStopInput(time: _controllers[i].text, stopId: _schedule[i].stop.id);
      scheduleInput.add(new_stop);
    }
    return ScheduleInput(
      name:_nameController.text,
      start: _startController.text,
      end: _endController.text,
      routeId: _selectedRoute!.id!,
      schedule: scheduleInput,
      );
  }
  
  void _createSchedule() async{
    ScheduleInput scheduleInput = _getScheduleInput();
    await _graphQLService.createSchedule(scheduleInput: scheduleInput);
  }


  // void editSchedule(){
  // }
  // void deleteSchedule(){
  // }

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
            TextField(
              controller: _nameController, 
              decoration: InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            DropdownButton<RouteModel>(
              hint: Text('Выберите маршрут'),
              value: _selectedRoute,
              onChanged: (RouteModel? newValue) async{
                await _loadRoute(newValue!);
              },
              items: _availableRoutes.map((RouteModel route) {
                return DropdownMenuItem<RouteModel>(
                  value: route,
                  child: Text('${route.start!.name} - ${route.end!.name}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_selectedRoute != null) ...[
              Text(
                'Остановки для маршрута ${_selectedRoute!.start!.name} - ${_selectedRoute!.end!.name}:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _schedule.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_schedule[index].stop.name),
                          Container(
                            width: 100, 
                            child: TextField(
                              controller: _controllers[index],
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
                controller:_startController,
                decoration: InputDecoration(
                  labelText: 'Время начала',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller:_endController,
                decoration: InputDecoration(
                  labelText: 'Время конца',
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _createSchedule, 
                  child: Text('Добавить Маршрут'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), 
                  ),
                ),
              ),

            ],
          ],
        ),
      ),
    );
  }

}