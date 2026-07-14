import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_input_screen.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class ConfirmScreen extends StatefulWidget {
  final String ordem;
  final String codigoProduto; 
  final int quantidade;
  final int meta;
  final String funcionario;
  final String funcionarioId;
  final String setor;

  const ConfirmScreen({
    super.key,
    required this.ordem,
    required this.codigoProduto, 
    required this.quantidade,
    required this.meta,
    required this.funcionario,
    required this.funcionarioId,
    required this.setor,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  bool loading = false;

  Future<void> salvar() async {
    try {
      setState(() => loading = true);

      await FirebaseFirestore.instance.collection('apontamentos').add({
        'ordem': widget.ordem,
        'codigo_produto': widget.codigoProduto, 
        'quantidade': widget.quantidade,
        'meta': widget.meta,
        'funcionario': widget.funcionario,
        'funcionarioId': widget.funcionarioId,
        'setor': widget.setor,
        'status': 'finalizado',
        'data': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apontamento finalizado'),
          backgroundColor: AppColors.success,
        ),
      );

      /// VOLTA PRA TELA DE ORDEM (mantém operador)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => OrderInputScreen(
            setor: widget.setor,
            funcionario: widget.funcionario,
            funcionarioId: widget.funcionarioId,
          ),
        ),
        (route) => false,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  void cancelar() {
    /// VOLTA PRA PRODUÇÃO (mantém dados)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndustrialBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: largura > 600 ? 480 : double.infinity,
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// CARD
                    AppCard(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [

                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.success.withOpacity(0.12),
                              border: Border.all(color: AppColors.success, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 40,
                              color: AppColors.success,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text('CONFIRMAR APONTAMENTO', style: AppText.eyebrow),

                          const SizedBox(height: 6),

                          Text('Revise antes de enviar', style: AppText.subtitle),

                          const SizedBox(height: 26),

                          _item('Funcionário', widget.funcionario, Icons.badge_outlined),
                          _item('Setor', widget.setor, Icons.factory_outlined),
                          _item('OF', widget.ordem, Icons.qr_code_2_outlined),
                          _item('Cód. Produto', widget.codigoProduto, Icons.inventory_2_outlined), // ← novo
                          _item('Produzido', widget.quantidade.toString(), Icons.check_circle_outline),
                          _item('Meta', widget.meta.toString(), Icons.flag_outlined),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// CONFIRMAR
                    loading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: CircularProgressIndicator(color: AppColors.primary),
                          )
                        : PrimaryButton(
                            label: 'CONFIRMAR',
                            icon: Icons.send_rounded,
                            onPressed: salvar,
                            colorStart: AppColors.success,
                            colorEnd: AppColors.successDark,
                          ),

                    const SizedBox(height: 10),

                    /// CANCELAR
                    TextButton(
                      onPressed: loading ? null : cancelar,
                      child: Text('Cancelar', style: AppText.label),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(String titulo, String valor, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceSunken,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Text(titulo, style: AppText.label),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                valor,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: AppText.body.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
