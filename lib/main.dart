import 'package:flutter/material.dart';
import 'package:schedule_app/screens/profile.dart';
import 'package:schedule_app/screens/stoplist.dart';
import 'package:schedule_app/admin/adminpanel.dart';
import 'screens/buslist.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Приложение с Нижним Меню',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Индекс выбранного экрана

  // Список экранов
  final List<Widget> _screens = [
    // BusListScreen(),
    // StopScreen(),
    // ProfileScreen(),
    AdminPanel(),
    // HomeScreen(),
    // TestListScreen()
  ];

  void _onItemTapped(int index) {
    
    setState(() {
      _selectedIndex = index; // Обновление выбранного индекса
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Приложение с Нижним Меню'),
      ),
      body: _screens[_selectedIndex], // Отображение выбранного экрана
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Автобусы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Остановки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'test',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Обработчик нажатий
      ),
    );
  }
}

