import 'package:flutter/material.dart';

class Stop {
  final int id;
  final int bus;
  final String name;

  Stop({required this.id, required this.bus, required this.name});
}

class StopListScreen extends StatelessWidget {
  final List<Stop> stops = [
    Stop(id: 1, bus: 101, name: 'Финиш A'),
    Stop(id: 2, bus: 102, name: 'Финиш C'),
    Stop(id: 3, bus: 103, name: 'Финиш E'),
    // Добавьте больше автобусов здесь
  ];

   StopListScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Остановок'),
      ),
      body: ListView.builder(
        itemCount: stops.length,
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
                        Text('${stops[index].bus}', style: TextStyle(fontSize: 18)),
                        // SizedBox(height: 4),
                      ],
                    ),
                    ),

                  ),
                  // VERTICAL DIVIDER
                  // Container(
                  //   width: 3, // Ширина разделителя
                  //   height: 40, // Высота разделителя
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
                        Text('${stops[index].name}', style: TextStyle(fontSize: 16)),
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
    // Добавьте больше автобусов здесь
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
            trailing: Icon(Icons.arrow_forward), // Иконка стрелочки
            onTap: () {
              // Действие при нажатии на элемент списка (если нужно)
              print('Нажат автобус номер ${buses[index].number}');
            },
          );
        },
      ),
    );
  }
}
