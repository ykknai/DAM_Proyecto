import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_dam/services/fs_service.dart';
import 'package:proyecto_dam/widgets/form_campo.dart';

class EventosAgregar extends StatefulWidget {
  EventosAgregar({super.key});

  @override
  State<EventosAgregar> createState() => _EventosAgregarState();
}

class _EventosAgregarState extends State<EventosAgregar> {
  final formKey = GlobalKey<FormState>();

  TextEditingController autorCtrl = TextEditingController();
  TextEditingController categoriaCtrl = TextEditingController();
  TextEditingController fechaCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController tituloCtrl = TextEditingController();

  DateTime fechaEvento = DateTime.now();
  String? categoriaSeleccionada;
  String? errorFecha;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      autorCtrl.text = user.displayName ?? user.email ?? 'Usuario anónimo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF003566),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF001530), Color(0xFF003566), Color(0xFF0353A4)],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
          ),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                FormCampo(
                  child: TextFormField(
                    controller: autorCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Autor',
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (nombre) {
                      if (nombre!.isEmpty) {
                        return 'Indique el nombre del autor';
                      }
                      return null;
                    },
                  ),
                ),
                //Titulo
                FormCampo(
                  child: TextFormField(
                    controller: tituloCtrl,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      prefixIcon: Icon(Icons.title, color: Colors.blue),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (titulo) {
                      if (titulo!.isEmpty) {
                        return 'Indique el título';
                      }
                      if (titulo.length < 10) {
                        return 'Título mínimo de 10 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                //Lugar
                FormCampo(
                  child: TextFormField(
                    controller: lugarCtrl,
                    decoration: InputDecoration(
                      labelText: 'Lugar',
                      prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (lugar) {
                      if (lugar!.isEmpty) return 'Indique el lugar';
                      if (lugar.length < 3) {
                        return 'Lugar mínimo de 3 caracteres';
                      }
                      if (lugar.length >= 20) {
                        return 'Lugar supera el maximo de 20 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                // Categoria
                FormCampo(
                  child: StreamBuilder(
                    stream: FsService().categorias(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Cargando categorías...');
                      }
                      var categorias = snapshot.data!.docs;
                      return DropdownButtonFormField(
                        validator: (categoria) {
                          if (categoria == null) {
                            return 'Indique la categoría';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          prefixIcon: Icon(Icons.category, color: Colors.blue),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria['nombre'].toString(),
                            child: Text(categoria['nombre']),
                          );
                        }).toList(),
                        onChanged: (categoria) {
                          categoriaSeleccionada = categoria;
                        },
                      );
                    },
                  ),
                ),
                //Fecha y Hora
                SizedBox(
                  width: double.infinity,
                  child: DateTimePickerEvento(
                    onDateTimeChanged: (value) {
                      fechaEvento = value;
                    },
                    color: Colors.blue,
                  ),
                ),

                SizedBox(height: 20),
                //Agregar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF003566),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Agregar Evento',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await FsService().agregarEvento(
                          autorCtrl.text.trim(),
                          categoriaSeleccionada!,
                          fechaEvento,
                          lugarCtrl.text.trim(),
                          tituloCtrl.text.trim(),
                          FirebaseAuth.instance.currentUser!.uid,
                        );
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                //Volver
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 24, 134, 237),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Volver',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimePickerEvento extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  final Color color;

  const DateTimePickerEvento({
    super.key,
    required this.onDateTimeChanged,
    required this.color,
  });

  @override
  State<DateTimePickerEvento> createState() => _DateTimePickerEventoState();
}

class _DateTimePickerEventoState extends State<DateTimePickerEvento> {
  DateTime? fechaSeleccionada;

  String formatFecha(DateTime fecha) {
    return DateFormat('dd/MM/yyyy HH:mm').format(fecha);
  }

  Future<void> seleccionarFechaYHora() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: widget.color)),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      final TimeOfDay? hora = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(
              context,
            ).copyWith(colorScheme: ColorScheme.light(primary: widget.color)),
            child: child!,
          );
        },
      );

      if (hora != null) {
        final fechaHoraFinal = DateTime(
          fecha.year,
          fecha.month,
          fecha.day,
          hora.hour,
          hora.minute,
        );

        setState(() {
          fechaSeleccionada = fechaHoraFinal;
        });

        widget.onDateTimeChanged(fechaHoraFinal);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(MdiIcons.calendarClock, color: widget.color),
          SizedBox(width: 10),
          Text(
            fechaSeleccionada != null
                ? formatFecha(fechaSeleccionada!)
                : 'Seleccionar fecha y hora',
            style: TextStyle(
              color: fechaSeleccionada != null ? Colors.black : Colors.grey,
              fontWeight: fechaSeleccionada != null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.edit_calendar_outlined, color: widget.color),
            onPressed: seleccionarFechaYHora,
          ),
        ],
      ),
    );
  }
}
