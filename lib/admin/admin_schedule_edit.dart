import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_services/graph_route_service.dart';
import 'package:schedule_app/graph_ql_services/graph_sched_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';
import 'package:schedule_app/graph_ql_services/graphql_st_service.dart';

class NewScheduleScreen extends StatefulWidget {
  int? id;
  NewScheduleScreen({this.id});

  @override
  _RouteSelectionScreenState createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<NewScheduleScreen> {
  
  final RouteGraphQLService _routeGraphQLService = RouteGraphQLService();
  final StopGraphQLService _stopGraphQLService = StopGraphQLService();
  final ScheduleGraphQLService _graphQLService= ScheduleGraphQLService();


  List<RouteModel> _availableRoutes=[]; 
  RouteModel? _selectedRoute;
  List<SchedulStopModel>  _schedule = [];
  int? _selectedRouteId;
  List<StopModel> _stops = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  List<TextEditingController> _controllers = [];
  
  void _loadRoute(RouteModel route,int kost) async{
    if(kost==1){
      print("kost1");
      List<RouteModel> filteredRoutes = _availableRoutes.where(
        (routt) => routt.id == route.id).toList();
      _loadRoute(filteredRoutes[0],0);
    }else{
      print("kost2");
      // тут еще можно проверить грузился ли он до этого
      int routeIndex = _availableRoutes.indexOf(route);
      print(routeIndex);
      RouteModel new_route = await _routeGraphQLService.getRouteById(id:route.id);
      print('dab');
      _availableRoutes[routeIndex] = new_route;
      setState(() {
        _selectedRoute = new_route;
      });
      print('da?');

      // #kost надо переделать чтобы рисовалось не из _selectedRoute а из schedule или стопс
      _stops = _selectedRoute!.stops ?? [];
      // _schedule = List.generate(_stops.length,()=>)
      _schedule = _stops.map((stop) {
        return SchedulStopModel(id: 123, time:"",stop:stop);
      }).toList();
      
      // _schedule = List.
      _controllers = List.generate(_stops.length, (index) => TextEditingController());
    }
    
  }

  
  void _loadRoutes() async {
    _availableRoutes = [];
    List<RouteModel> availableRoutes = await _routeGraphQLService.getRoutes();
    setState(() => _availableRoutes = availableRoutes);
  }
  
  ScheduleInput _toScheduleInput(){

    List<ScheduleStopInput> scheduleInput = [];
    print("here");
    for (int i = 0; i < _stops.length; i++) {
      ScheduleStopInput new_stop = ScheduleStopInput(time: _controllers[i].text, stopId: _stops[i].id);
      print(new_stop.stopId);
      print(new_stop.time);
      scheduleInput.add(new_stop);
    }
    print(scheduleInput);
    return ScheduleInput(
      name:_nameController.text,
      start: _startController.text,
      end: _endController.text,
      routeId: _selectedRoute!.id,
      schedule: scheduleInput,
      );
  }
  
  void _createSchedule() async{
    ScheduleInput scheduleInput = _toScheduleInput();
    print('create');
    print(scheduleInput);
    await _graphQLService.createSchedule(scheduleInput: scheduleInput);
  }

  void _loadSchedule(int scheduleId) async{
    ScheduleModel schedule = await _graphQLService.getScheduleById(id: scheduleId);
    _nameController.text =schedule.name;
    _startController.text = schedule.start;
    _endController.text = schedule.end;
    // _controllers
    print('norm');

    // _loadRoute(schedule.route, 1);
    
  }
  @override
  void initState() {
    super.initState();
    print("a tyty");
    _loadRoutes();
    if (widget.id != null) {
        _loadSchedule(widget.id!); 
    }
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
              controller: _nameController, // Привязка контроллера к текстовому полю
              decoration: InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            DropdownButton<RouteModel>(
              hint: Text('Выберите маршрут'),
              value: _selectedRoute,
              onChanged: (RouteModel? newValue) {
                setState(() {
                  _loadRoute(newValue!,0);
                });
              },
              items: _availableRoutes.map((RouteModel route) {
                return DropdownMenuItem<RouteModel>(
                  value: route,
                  child: Text('${route.start.name} - ${route.end.name}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_selectedRoute != null) ...[
              Text(
                'Остановки для маршрута ${_selectedRoute!.start.name} - ${_selectedRoute!.end.name}:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _stops.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_stops[index].name),
                          Container(
                            width: 100, // Фиксированная ширина для поля ввода
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
                onChanged: (value) {
                  // startTime = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller:_endController,
                decoration: InputDecoration(
                  labelText: 'Время конца',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // endTime = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _createSchedule, // Логика для добавления нового маршрута
                  child: Text('Добавить Маршрут'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
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