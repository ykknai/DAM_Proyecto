import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_dam/pages/new_event.dart';
import 'package:proyecto_dam/services/fs_service.dart';
import 'package:proyecto_dam/pages/details_events.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_dam/utils/app_utils.dart';

class TodosEventosPage extends StatefulWidget {
  TodosEventosPage({super.key});

  @override
  State<TodosEventosPage> createState() => _TodosEventosPageState();
}

class _TodosEventosPageState extends State<TodosEventosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String formatearFecha(Timestamp fecha) {
    DateTime fechaDateTime = fecha.toDate();
    return DateFormat('dd/MM/yyyy hh:mm').format(fechaDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Todos los Eventos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff003566),
        elevation: 1,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000814),
              Color(0xFF001530),
              Color(0xFF002855),
              Color(0xFF003566),
            ],
            stops: [0.0, 0.4, 0.75, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: StreamBuilder(
          stream: FsService().eventos(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No hay eventos registrados.',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var evento = snapshot.data!.docs[index];
                final data = evento.data() as Map<String, dynamic>;
                final esPropietario = data['uid'] == user?.uid;

                return Slidable(
                  enabled: esPropietario,
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          bool
                          aceptaBorrar = await AppUtils.mostrarConfirmacion(
                            context,
                            'Confirmar Eliminación',
                            '¿Esta seguro de eliminar el evento: ${evento['titulo']}?',
                          );
                          if (aceptaBorrar) {
                            await FsService().borrarEvento(evento.id).then((
                              acepto,
                            ) {
                              if (acepto) {
                                AppUtils.mostrarSnackbar(
                                  _scaffoldKey.currentContext!,
                                  'Evento eliminado correctamente.',
                                );
                                setState(() {});
                              }
                            });
                          }
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Eliminar',
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalleEventoPage(id: evento.id),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Seleccionaste: ${evento['titulo']}'),
                          backgroundColor: Colors.blueGrey,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xff003566),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              MdiIcons.calendarClock,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  evento['titulo'] ?? 'Sin título',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff001d3d),
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Categoria: ${evento['categoria']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_history,
                                      color: Colors.blueGrey,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Lugar: ${evento['lugar']}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      MdiIcons.calendar,
                                      color: Colors.blueGrey,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Fecha: ${formatearFecha(evento['fecha'])}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.blueAccent,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "eventos_fab",
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventosAgregar()),
          );
        },
      ),
    );
  }
}
