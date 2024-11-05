import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';


class StopEditScreen extends StatefulWidget {
  int? stopId;
  StopEditScreen({this.stopId});

  @override
  _StopEditScreenState createState() => _StopEditScreenState();
}

class _StopEditScreenState extends State<StopEditScreen> 
  with SingleTickerProviderStateMixin{

  final GraphQLService _graphQLService = GraphQLService();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (widget.stopId != null) {
      await _loadStop(widget.stopId!); 
    }
  }

  StopInput _getStopInput(){
    return StopInput(name: _nameController.text);
  }

  Future<void> _loadStop(int stopId) async{
    StopModel stop = await _graphQLService.getStopById(stopId:stopId);
    _nameController.text = stop.name;
  }
  
  Future<void> _addStop() async {
    StopInput stopInput = _getStopInput();
    await _graphQLService.createStop(stopInput:stopInput);
  }

  Future<void> _editStop(int stopId) async {
    StopInput stopInput = _getStopInput();
    await _graphQLService.editStop(stopId:stopId,stopInput:stopInput);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ввод Имени'),
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
            ElevatedButton(
              onPressed: () {
                if (widget.stopId != null) {
                  _editStop(widget.stopId!);
                } else {
                  _addStop();
                }
              },
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