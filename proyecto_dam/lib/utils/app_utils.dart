import 'package:flutter/material.dart';

class AppUtils {
  static mostrarSnackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  static Future<bool> mostrarConfirmacion(
    BuildContext context,
    String titulo,
    String mensaje,
  ) async {
    final resultado = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          iconColor: Colors.red,
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            OutlinedButton(
              child: Text('CANCELAR'),
              onPressed: () => Navigator.pop(context, false),
            ),
            FilledButton(
              child: Text(
                'ELIMINAR',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    return resultado ?? false;
  }
}
