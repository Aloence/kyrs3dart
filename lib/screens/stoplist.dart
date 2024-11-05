import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';

class StopsListScreen extends StatefulWidget {
  const StopsListScreen({super.key});

  @override
  _StopsListScreenState createState() => _StopsListScreenState();
}

class _StopsListScreenState extends State<StopsListScreen>
    with SingleTickerProviderStateMixin {
  final GraphQLService _graphQLService = GraphQLService();

  List<StopModel>? _stops;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadStops();
  }


  Future<void> _loadStops() async {
    _stops = null;
    List<StopModel> stops = await _graphQLService.getStops();
    setState(() => _stops = stops);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Остановок'),
      ),
      body: ListView.builder(
        itemCount: _stops!.length,
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
                        Text('mock pozor', style: TextStyle(fontSize: 18)),
                        // Text('${_stops![index].bus}', style: TextStyle(fontSize: 18)),
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
                    child:InkWell(
                    
                    onTap: ()=>{
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StopBusScreen(),
                        ),
                      )},
                    child: InkWell(
                      child: Center(
                      
                      child:Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_stops![index].name}', style: TextStyle(fontSize: 16)),
                      ],
                      
                    ),
                    ),
                    ),
                    )
  
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

class Bus {
  final int number;
  final String finish;

  Bus({required this.number, required this.finish});
}

class StopBusScreen extends StatelessWidget {
  final List<Bus> buses = [
    Bus(number: 101, finish: 'Станция A'),
    Bus(number: 102, finish: 'Станция B'),
    Bus(number: 103, finish: 'Станция C'),
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Остановка'),
      ),
      body: ListView.builder(
        itemCount: buses.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.all(16.0),
            leading: Icon(Icons.bus_alert),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus ${buses[index].number}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${buses[index].finish}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward), 
            onTap: () {
             
              print('Нажат автобус номер ${buses[index].number}');
            },
          );
        },
      ),
    );
  }
}
