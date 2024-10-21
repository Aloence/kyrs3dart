import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String avatarUrl = 'https://example.com/avatar.png'; // URL аватарки
  final String username = 'user123'; // Логин
  final String fullName = 'Иван Иванов'; // Имя
  final double balance = 150.75; // Баланс

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Row(
              children:[
                CircleAvatar(
                  radius: 50, // Радиус аватарки
                  child: Icon(
                    Icons.person, // Иконка пользователя
                    size: 75, // Размер иконки
                    color: Colors.white, // Цвет иконки
                  ), // Загрузка изображения по URL
                ),
                Expanded(child:  
                Column(children: [
                  SizedBox(height: 16), // Отступ между аватаркой и текстом
                  Text(
                    fullName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Отступ
                  Text(
                    username,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 16), // Отступ
                  Text(
                    'Баланс: \$${balance.toStringAsFixed(2)}', // Форматирование баланса до 2 знаков после запятой
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],))
               
              ]
            ),
    
            Row(children: [
              Center(
                child:   ElevatedButton(
              onPressed: () {
                // Действие при нажатии на кнопку "Выйти"
                print('Выход из профиля'); // Здесь можно добавить логику выхода
              },
              child: Text('Выйти'),
              // style: ElevatedButton.styleFrom(
              //   minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
              // ),
            ),
              )


          ],
        ),
        ],
      ),
      ),
    );
  }
}