import '../models/apontamento.dart';

class ApiService {
  static Future<void> enviarApontamento(Apontamento apontamento) async {
  
    await Future.delayed(const Duration(seconds: 1));

    print("Enviado:");
    print(apontamento.toJson());
  }
}