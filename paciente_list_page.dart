import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'paciente_form_page.dart';
import 'paciente_service.dart';

class PacienteListPage extends StatefulWidget {
  @override
  _PacienteListPageState createState() => _PacienteListPageState();
  
}

class _PacienteListPageState extends State<PacienteListPage> {
  
  @override
  void initState() {
    super.initState();
    fetchPacientes();
  }

  List<dynamic> pacientes = [];

  final PacienteService pacienteService = PacienteService();

  Future<void> fetchPacientes() async {
    List<Map<String, dynamic>> data = await pacienteService.getAllPacientes();
    setState(() {
      pacientes = data;
    });
  }

  Future<void> deletePaciente(int id) async {
    await pacienteService.deletePaciente(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder:(context) =>  PacienteListPage())
      );
  }

  void editPaciente(int id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientForm(id: id),
      ),
    );
  }

  String formatarData(String data) {
    final DateTime dateTime = DateTime.parse(data);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pacientes'),
      ),
      body: pacientes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pacientes.length,
              itemBuilder: (context, index) {
                final paciente = pacientes[index];
                return ListTile(
                  title: Text(paciente['nm_pessoa'].toString().toUpperCase()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CPF: ${paciente['nu_cpf']}'),
                      Text(
                          'Data de nascimento: ${formatarData(paciente['dt_nascimento'])}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editPaciente(paciente['id_paciente']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            deletePaciente(paciente['id_paciente']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => PatientForm()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
