import 'package:flutter/material.dart';
import 'paciente_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  
      title: 'Pacientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PacienteListPage(), 
    );
  }
}
