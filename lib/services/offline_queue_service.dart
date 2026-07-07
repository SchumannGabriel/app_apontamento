import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfflineQueueService {
  static const String key = 'fila_apontamentos';

  ///  SALVA LOCAL
  static Future<void> salvar(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(key) ?? [];

    lista.add(jsonEncode(data));
    await prefs.setStringList(key, lista);
  }

  ///  TENTA ENVIAR FILA
  static Future<void> processarFila() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(key) ?? [];

    if (lista.isEmpty) return;

    final novaLista = <String>[];

    for (var item in lista) {
      try {
        final data = jsonDecode(item);

        await FirebaseFirestore.instance
            .collection('apontamentos')
            .add(data);
      } catch (e) {
        novaLista.add(item); // mantém na fila se falhar
      }
    }

    await prefs.setStringList(key, novaLista);
  }
}