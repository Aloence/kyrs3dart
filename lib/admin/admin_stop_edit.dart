import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';
import 'package:schedule_app/graph_ql_services/graphql_st_service.dart';



class StopEditScreen extends StatelessWidget {
  StopModel?stop; // Переменная для хранения имени

  StopEditScreen({this.stop}); // Конструктор для получения значения name

  final StopGraphQLService _graphQLService = StopGraphQLService();
  final TextEditingController _nameController = TextEditingController();


  StopInput _toStopInput(String name){
    return StopInput(name: name);
  }

  void _addStop(StopInput stopInput) async {
    await _graphQLService.createStop(stopInput:stopInput);
  }

  void _editStop(int id, StopInput stopInput) async {
    await _graphQLService.editStop(id:id,stopInput:stopInput);
  }

  @override
  Widget build(BuildContext context) {
    // Устанавливаем текст в текстовом поле
    _nameController.text = stop?.name ?? ''; 
    // _nameController.text ="dadada";

    return Scaffold(
      appBar: AppBar(
        title: Text('Ввод Имени'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController, // Привязка контроллера к текстовому полю
              decoration: InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16), // Отступ между текстовым полем и кнопкой
            ElevatedButton(
              onPressed: () {
                // Логика при нажатии на кнопку
                String enteredName = _nameController.text; // Получаем текст из текстового поля
                print('Введенное имя: $enteredName');
                  if (stop != null) {
                  // Если объект stop передан, вызываем метод редактирования
                  _editStop(stop!.id, _toStopInput(enteredName));
                } else {
                  // Если объект stop не передан, вызываем метод добавления
                  _addStop(_toStopInput(enteredName));
                }
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