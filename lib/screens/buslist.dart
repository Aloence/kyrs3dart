import 'package:flutter/material.dart';

class Bus {
  final int id;
  final int number;
  final String start;
  final String finish;

  Bus({required this.id, required this.number, required this.start, required this.finish});
}

class BusListScreen extends StatelessWidget {
  final List<Bus> buses = [
    Bus(id: 1, number: 101, start: 'Станция A', finish: 'Станция B'),
    Bus(id: 2, number: 102, start: 'Станция C', finish: 'Станция D'),
    Bus(id: 3, number: 103, start: 'Станция E', finish: 'Станция F'),
  ];

  Future<List<Map<String, dynamic>>> fetchSch() async {
    // kost
    return [
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
  }
   BusListScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Автобусов'),
      ),
      body: ListView.builder(
        itemCount: buses.length,
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
                        Text('${buses[index].number}', style: TextStyle(fontSize: 18)),
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
                        Text('${buses[index].start}', style: TextStyle(fontSize: 16)),
                        Text('${buses[index].finish}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child:Center(
                      child:IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () async {
                      
                      List<Map<String, dynamic>> sch = await fetchSch();
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchListScreen(sch: sch),
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
  final List<Map<String, dynamic>> sch;

  SchListScreen({required this.sch});

  // final List<Map<String, dynamic>> sch = [
  //   {
  //     'id': 1,
  //     'stop': {'stop_id': 101, 'stop_name': 'Станция A'},
  //     'time': '10:00',
  //   },
  //   {
  //     'id': 2,
  //     'stop': {'stop_id': 102, 'stop_name': 'Станция B'},
  //     'time': '10:30',
  //   },
  //   {
  //     'id': 3,
  //     'stop': {'stop_id': 103, 'stop_name': 'Станция C'},
  //     'time': '11:00',
  //   },
  //   
  // ];

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