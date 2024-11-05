import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_services/graph_bus_service.dart';
import 'package:schedule_app/graph_ql_services/graph_sched_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';

class NewBusScreen extends StatefulWidget {
  int? id;
  NewBusScreen({this.id});

  @override
  _BusEditScreenState createState() => _BusEditScreenState();
}

class _BusEditScreenState extends State<NewBusScreen> {

  final BusGraphQLService  _graphQLService = BusGraphQLService();
  final ScheduleGraphQLService _scheduleGraphQLService = ScheduleGraphQLService();

  ScheduleModel? _selectedSchedule;
  List<ScheduleModel> _availableSchedules=[]; 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  
  void _loadSchedules() async {
    _availableSchedules = [];
    List<ScheduleModel> availableSchedules = await _scheduleGraphQLService.getSchedules();
    setState(() => _availableSchedules = availableSchedules);
  }

  BusInput _toBusInput(){
    return BusInput(
      name: _nameController.text, 
      price: 
      // #kost
      double.parse(_priceController.text), 
      scheduleId: _selectedSchedule!.id,
      );
  }

  void _loadBus(int busId) async{
    BusModel bus = await _graphQLService.getBusById(busId: busId);
    _nameController.text =bus.name;
    _priceController.text = bus.price.toString();
    
    List<ScheduleModel> filteredSchedule = _availableSchedules.where(
      (schedule) => schedule.id == bus.schedule.id).toList();
    print('tesst');
    print(filteredSchedule[0]==bus.schedule);
    setState(() {
      // #kost надо чтобы одно возвроащалсь а не список
      
      // _selectedSchedule = filteredSchedule[0];
      _selectedSchedule = bus.schedule;
    });
    

  }
  void _createBus() async {
    BusInput busInput = _toBusInput();
    await _graphQLService.createBus(busInput: busInput);
  }

  @override
  void initState() {
    super.initState();
    _loadSchedules();
    if (widget.id != null) {
      print('iiooo');
      print(widget.id);
       _loadBus(widget.id!);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование Автобуса'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Номер автобуса'),
              // keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Цена'),
              // keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            DropdownButton<ScheduleModel>(
              hint: Text('Выберите расписание'),
              value: _selectedSchedule,
              onChanged: (ScheduleModel? newValue) {
                setState(() {
                  _selectedSchedule = newValue;
                });
              },
              items: _availableSchedules.map((ScheduleModel schedule) {
                return DropdownMenuItem<ScheduleModel>(
                  value: schedule,
                  child: Text('Расписание №${schedule.name}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createBus,
              child: Text('Сохранить'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Кнопка на всю ширину
              ),
            ),
          ],
        ),
      ),
    );
  }
}