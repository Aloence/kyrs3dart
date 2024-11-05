import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';

class BusEditScreen extends StatefulWidget {
  int? busId;
  BusEditScreen({this.busId});

  @override
  _BusEditScreenState createState() => _BusEditScreenState();
}

class _BusEditScreenState extends State<BusEditScreen> {

  final GraphQLService _graphQLService = GraphQLService();

  ScheduleModel? _selectedSchedule;
  List<ScheduleModel> _availableSchedules=[]; 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSchedules();
    if (widget.busId != null) {
      await _loadBus(widget.busId!); 
    }
  }
  Future<void> _loadSchedules() async {
    _availableSchedules = [];
    List<ScheduleModel> availableSchedules = await _graphQLService.getSchedules();
    setState(() => _availableSchedules = availableSchedules);
  }

  Future<void> _loadBus(int busId) async{
    BusModel bus = await _graphQLService.getBusById(busId: busId);

    _nameController.text =bus.name;
    _priceController.text = bus.price.toString();

    // #kost или нет?
    List<ScheduleModel> filteredSchedule = _availableSchedules.where(
      (schedule) => schedule.id == bus.schedule.id).toList();

    setState(() {
      _selectedSchedule = filteredSchedule[0];
    });
    

  }

  BusInput _toBusInput(){
    return BusInput(
      name: _nameController.text, 
      price: 123,
      // #kost
      // double.parse(_priceController.text), 
      scheduleId: _selectedSchedule!.id!,
      );
  }

  Future<void> _createBus() async {
    BusInput busInput = _toBusInput();
    await _graphQLService.createBus(busInput: busInput);
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
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}