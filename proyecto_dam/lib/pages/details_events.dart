import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_dam/services/fs_service.dart';

class DetalleEventoPage extends StatelessWidget {
  final String id;

  DetalleEventoPage({super.key, required this.id});

  String formatearFecha(Timestamp fecha) {
    DateTime fechaDateTime = fecha.toDate();
    return DateFormat('dd/MM/yyyy').format(fechaDateTime);
  }

  String formatearHora(Timestamp fecha) {
    DateTime fechaDateTime = fecha.toDate();
    return DateFormat('hh:mm a').format(fechaDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle del Evento',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xff003566),
        centerTitle: true,
        elevation: 6,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff000814),
              Color(0xff00122b),
              Color(0xff00204a),
              Color(0xff003566),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: FsService().eventoId(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  'No se encontró información del evento.',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              );
            }

            var evento = snapshot.data!;

            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Card(
                  elevation: 12,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              MdiIcons.informationOutline,
                              color: Color(0xff003566),
                              size: 32,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                evento['titulo'] ?? 'Sin título',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff001d3d),
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Categoria: ${evento['categoria']}',
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        Divider(height: 30, thickness: 1.2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_history,
                              color: Colors.blueGrey,
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Lugar: ${evento['lugar']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              MdiIcons.calendar,
                              color: Colors.blueGrey,
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Fecha: ${formatearFecha(evento['fecha'])}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              MdiIcons.clockOutline,
                              color: Colors.blueGrey,
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Hora: ${formatearHora(evento['fecha'])}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              MdiIcons.account,
                              color: Colors.blueGrey,
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Autor: ${evento['autor']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                            label: Text('Volver'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff003566),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
