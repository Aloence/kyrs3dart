import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';

class BusesListScreen extends StatefulWidget {
  const BusesListScreen({super.key});

  @override
  _BusesListScreenState createState() => _BusesListScreenState();
}

class _BusesListScreenState extends State<BusesListScreen>{
  final GraphQLService _graphQLService = GraphQLService();
  
  List<BusModel>? _buses = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadBuses();
  }

  Future<void> _loadBuses() async {
    _buses = null;
    List<BusModel> buses = await _graphQLService.getBuses();
    setState(() => _buses = buses);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Автобусов'),
      ),
      body: ListView.builder(
        itemCount: _buses!.length,
        itemBuilder: (context, index) {
          return Card(
            // margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(          
                children: [
                  Expanded(
                    flex:1,
                    child: Center(
                      child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.directions_bus),
                        Text('${_buses![index].name}', style: TextStyle(fontSize: 18)),
                        // SizedBox(height: 4),
                      ],
                    ),
                    ),
                  ),
                  // VERTICAL DIVIDER
                  // Container(
                  //   width: 3, 
                  //   height: 40,
                  //   color: Colors.grey,
                  // ),
                  Expanded(
                    flex:3,
                    child: Center(
                      child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_buses![index].schedule.route!.start!.name}', style: TextStyle(fontSize: 16)),
                        Text('${_buses![index].schedule.route!.end!.name}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child:Center(
                      child:IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchListScreen(),
                          ),
                        );
                    },
                    ),
                    ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class SchListScreen extends StatelessWidget {
  // final List<Map<String, dynamic>> sch;

  // SchListScreen({required this.sch});

  final List<Map<String, dynamic>> sch = [
    {
      'id': 1,
      'stop': {'stop_id': 101, 'stop_name': 'Станция A'},
      'time': '10:00',
    },
    {
      'id': 2,
      'stop': {'stop_id': 102, 'stop_name': 'Станция B'},
      'time': '10:30',
    },
    {
      'id': 3,
      'stop': {'stop_id': 103, 'stop_name': 'Станция C'},
      'time': '11:00',
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Маркированный список расписания'),
      ),
      body: ListView.builder(
        itemCount: sch.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.circle), 
            title: GestureDetector(
              // onTap: () => func1(sch[index]['id']), 
              child: Text(
                sch[index]['stop']['stop_name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: GestureDetector(
              // onTap: () => func1(sch[index]['id']),
              child: Text(
                sch[index]['time'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward), 
          
              onPressed: () => {}, 
            ),
          );
        },
      ),
    );
  }
}