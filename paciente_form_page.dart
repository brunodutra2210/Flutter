import 'package:appclinica/paciente_list_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'paciente_service.dart'; // Certifique-se de que este serviço está corretamente implementado

class PatientForm extends StatefulWidget {
  final int? id; // ID opcional para determinar se é edição ou inserção
  
  const PatientForm({Key? key, this.id}) : super(key: key);

  @override
  _PatientFormState createState() => _PatientFormState();
  
}

class _PatientFormState extends State<PatientForm> {
  
  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      // Se um ID for fornecido, carregue os dados do paciente para edição
      _getPaciente();
    }
  }

  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String cpf = '';
  DateTime? dataNascimento;
  bool isLoading = false; // Indicador de carregamento para o modo de edição

  final PacienteService pacienteService = PacienteService();


  // Método para obter os dados do paciente existente
  Future<void> _getPaciente() async {
    setState(() {
      isLoading = true;
    });
    var paciente = await pacienteService.getPaciente(widget.id!, context);
    if (paciente != null) {
      setState(() {
        nome = paciente['nm_pessoa'];
        cpf = paciente['nu_cpf'];
        dataNascimento = DateTime.parse(paciente['dt_nascimento']);
        isLoading = false;
      });
    } else {
      // Se o paciente não for encontrado, volte para a tela anterior
      Navigator.push(
        context,
        MaterialPageRoute(builder:(context) =>  PacienteListPage())).then((oi)=> setState(() {  
        }));
    }
  }

  // Método unificado para criar ou atualizar o paciente
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (dataNascimento == null) {
        // Verificação adicional para garantir que a data foi selecionada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma data de nascimento')),
        );
        return;
      }

      String dataFormatada = DateFormat('yyyy-MM-dd').format(dataNascimento!);

      Map<String, dynamic> paciente = {
        "nm_pessoa": nome,
        "nu_cpf": cpf,
        "Dt_Nascimento": dataFormatada,
      };

      if (widget.id == null) {
        // Modo de inserção
        await pacienteService.createPaciente(paciente, context);
      } else {
        // Modo de edição
        await pacienteService.updatePaciente(widget.id!, paciente, context);
      }

      // Após salvar, volte para a tela anterior
      Navigator.push(
      context,
      MaterialPageRoute(builder:(context) =>  PacienteListPage())
      );
    }
  }

  // Método para obter o texto da data selecionada
  String getText() {
    if (dataNascimento == null) {
      return 'Selecione uma data';
    } else {
      return DateFormat('dd/MM/yyyy').format(dataNascimento!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Defina o título e o texto do botão com base no modo
    String title = widget.id == null ? 'Cadastro de Paciente' : 'Editar Paciente';
    String buttonText = widget.id == null ? 'Salvar' : 'Atualizar';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Exibe um indicador de carregamento no modo de edição
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo para o nome
                    TextFormField(
                      initialValue: nome,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nome = value!;
                      },
                    ),
                    // Campo para o CPF
                    TextFormField(
                      initialValue: cpf,
                      decoration: const InputDecoration(labelText: 'CPF'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o CPF';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        cpf = value!;
                      },
                    ),
                    // Campo para a data de nascimento
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Data de Nascimento'),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: dataNascimento ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            dataNascimento = pickedDate;
                          });
                        }
                      },
                      controller: TextEditingController(
                        text: getText(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
