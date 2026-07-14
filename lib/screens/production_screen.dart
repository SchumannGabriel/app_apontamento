import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'confirm_screen.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class ProductionScreen extends StatefulWidget {
  final String setor;
  final String funcionario;
  final String funcionarioId;
  final String ordem;
  final String codigoProduto; 
  final int meta;

  const ProductionScreen({
    super.key,
    required this.setor,
    required this.funcionario,
    required this.funcionarioId,
    required this.ordem,
    required this.codigoProduto, 
    required this.meta,
  });

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  int quantidade = 0;
  String? docId;

  int get falta => widget.meta - quantidade;

  @override
  void initState() {
    super.initState();
    iniciarProducao();
  }

  Future<void> iniciarProducao() async {
    final doc = await FirebaseFirestore.instance
        .collection('producao_ativa')
        .add({
      'funcionarioId': widget.funcionarioId,
      'funcionario': widget.funcionario,
      'setor': widget.setor,
      'ordem': widget.ordem,
      'codigo_produto': widget.codigoProduto, 
      'meta': widget.meta,
      'quantidade': 0,
      'status': 'em andamento',
      'inicio': Timestamp.now(),
    });

    docId = doc.id;
  }

  void adicionar() {
    if (quantidade < widget.meta) {
      setState(() => quantidade++);
      if (docId != null) {
        FirebaseFirestore.instance
            .collection('producao_ativa')
            .doc(docId)
            .update({
          'quantidade': quantidade,
          'atualizado_em': Timestamp.now(),
        });
      }
    }
  }

  void remover() {
    if (quantidade > 0) {
      setState(() => quantidade--);
      if (docId != null) {
        FirebaseFirestore.instance
            .collection('producao_ativa')
            .doc(docId)
            .update({
          'quantidade': quantidade,
          'atualizado_em': Timestamp.now(),
        });
      }
    }
  }

  Future<void> finalizar() async {
    if (quantidade < widget.meta) {
      final ok = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surfaceRaised,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text('Meta não atingida', style: AppText.title.copyWith(fontSize: 18)),
          content: Text('Deseja finalizar mesmo assim?', style: AppText.body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Não', style: AppText.label),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sim'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    if (docId != null) {
      await FirebaseFirestore.instance
          .collection('producao_ativa')
          .doc(docId)
          .update({
        'status': 'finalizado',
        'finalizado_em': Timestamp.now(),
        'atualizado_em': Timestamp.now(),
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmScreen(
          setor: widget.setor,
          funcionario: widget.funcionario,
          funcionarioId: widget.funcionarioId,
          ordem: widget.ordem,
          codigoProduto: widget.codigoProduto, 
          quantidade: quantidade,
          meta: widget.meta,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndustrialBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Container(
                width: largura > 600 ? 500 : double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    /// CRACHÁ DO OPERADOR
                    OperatorBadge(nome: widget.funcionario, setor: widget.setor),

                    const SizedBox(height: 16),

                    /// OF + CÓDIGO DO PRODUTO
                    AppCard(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ORDEM DE FABRICAÇÃO', style: AppText.eyebrow),
                              const SizedBox(height: 4),
                              Text(
                                'OF ${widget.ordem}',
                                style: AppText.title.copyWith(fontSize: 20),
                              ),
                              const SizedBox(height: 6),
                              Text('CÓD. PRODUTO', style: AppText.eyebrow),
                              const SizedBox(height: 2),
                              Text(
                                widget.codigoProduto,
                                style: AppText.body.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceRaised,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'META ${widget.meta}',
                              style: AppText.label.copyWith(color: AppColors.amber),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// CONTADOR
                    DigitalCounterPanel(quantidade: quantidade, meta: widget.meta),

                    const SizedBox(height: 20),

                    /// BOTÕES +/-
                    Row(
                      children: [
                        Expanded(
                          child: TactileIconButton(
                            icon: Icons.remove,
                            color: AppColors.danger,
                            onTap: quantidade > 0 ? remover : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TactileIconButton(
                            icon: Icons.add,
                            color: AppColors.primary,
                            onTap: quantidade < widget.meta ? adicionar : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// FINALIZAR
                    PrimaryButton(
                      label: 'FINALIZAR',
                      icon: Icons.check_circle_outline,
                      onPressed: finalizar,
                      colorStart: AppColors.success,
                      colorEnd: AppColors.successDark,
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
}