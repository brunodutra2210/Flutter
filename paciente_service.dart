import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PacienteService {
  final String baseUrl = 'http://200.19.1.19/20212GR.ADS0014/BackPhp/public/index.php?controller=paciente';
  
Future<List<Map<String, dynamic>>> getAllPacientes() async {
  var url = Uri.parse('$baseUrl&action=index');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('Pacientes carregados');
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Erro ao carregar pacientes.');
    }
  } catch (e) {
    print('Erro ao carregar pacientes: $e');
    return [];
  }
}

  Future<void> createPaciente(Map<String, dynamic> paciente, BuildContext context) async {
    var url = Uri.parse('$baseUrl&action=store');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(paciente),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paciente cadastrado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no servidor: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar paciente! $e')),
      );
    }
  }

  Future<void> deletePaciente(int id) async{
    var url = Uri.parse('$baseUrl&action=delete&id=$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao carregar dados do paciente.');
      }
    } catch (e) {
      print('Erro ao deletar pacientes: $e');
    }
  }

  Future<Map<String, dynamic>?> getPaciente(int id, BuildContext context) async {
    var url = Uri.parse('$baseUrl&action=show&id=$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar dados do paciente.')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar paciente! $e')),
      );
      return null;
    }
  }

  Future<void> updatePaciente(int id, Map<String, dynamic> paciente, BuildContext context) async {
    var url = Uri.parse('$baseUrl&action=update&id=$id');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(paciente),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paciente atualizado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar paciente.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar paciente! $e')),
      );
    }
  }
}
