import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String avatarUrl = 'https://example.com/avatar.png'; 
  final String username = 'user123'; 
  final String fullName = 'Иван Иванов'; 
  final double balance = 150.75; 

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
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 75, 
                    color: Colors.white, 
                  ), 
                ),
                Expanded(child:  
                Column(children: [
                  SizedBox(height: 16), 
                  Text(
                    fullName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    username,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Баланс: \$${balance.toStringAsFixed(2)}', 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],))
               
              ]
            ),
    
            Row(children: [
              Center(
                child:   ElevatedButton(
              onPressed: () {
                
                print('Выход из профиля'); 
              },
              child: Text('Выйти'),
              // style: ElevatedButton.styleFrom(
              //   minimumSize: Size(double.infinity, 50), 
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