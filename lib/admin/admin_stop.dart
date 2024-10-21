import 'package:flutter/material.dart';


class Stop {
  final int id;
  final String name;

  Stop({required this.id, required this.name});
}

class AdminStopScreen extends StatelessWidget {
  final List<Stop> stops = [
    Stop(id: 1, name: 'Остановка A'),
    Stop(id: 2, name: 'Остановка B'),
    Stop(id: 3, name: 'Остановка C'),
    // Добавьте больше остановок здесь
  ];

  void _addStop(context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StopEditScreen(name:""),
      ),
    );
  }
  void _editStop(context, int id,String name) {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StopEditScreen(name:name),
      ),
    );
    
    // Логика для редактирования остановки
    print('Редактирование остановки с id: $id');
  }

  void _deleteStop(int id) {
    // Логика для удаления остановки
    print('Удаление остановки с id: $id');
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Остановок'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: stops.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          stops[index].name,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteStop(stops[index].id);
                        },
                        tooltip: 'Удалить',
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editStop(context,stops[index].id,"mock");
                        },
                        tooltip: 'Редактировать',
                      ),
                      
                    ],
                  ),
                );
              },
            ),
          ),
          // Кнопка внизу экрана
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Логика для добавления новой остановки
                _addStop(context);
                print('Добавление новой остановки');
              },
              child: Text('Добавить Остановку'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StopEditScreen extends StatelessWidget {
  final String name; // Переменная для хранения имени

  StopEditScreen({required this.name}); // Конструктор для получения значения name

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Устанавливаем текст в текстовом поле
    _controller.text = name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ввод Имени'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller, // Привязка контроллера к текстовому полю
              decoration: InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16), // Отступ между текстовым полем и кнопкой
            ElevatedButton(
              onPressed: () {
                // Логика при нажатии на кнопку
                String enteredName = _controller.text; // Получаем текст из текстового поля
                print('Введенное имя: $enteredName'); // Здесь можно добавить логику обработки имени
              },
              child: Text('Сохранить'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
              ),
            ),
          ],
        ),
      ),
    );
  }
}