import 'package:flutter/material.dart';
import 'confirm_screen.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class OrderScreen extends StatefulWidget {
  final String setor;
  final String funcionario;
  final String funcionarioId;

  const OrderScreen({
    super.key,
    required this.setor,
    required this.funcionario,
    required this.funcionarioId,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController ordemController = TextEditingController();

  int quantidade = 0;
  int meta = 0;

  Future<void> continuar() async {
    if (ordemController.text.isEmpty || quantidade <= 0 || meta == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha OF e quantidade')),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmScreen(
          setor: widget.setor,
          funcionario: widget.funcionario,
          funcionarioId: widget.funcionarioId,
          ordem: ordemController.text,
          quantidade: quantidade,
          meta: meta,
        ),
      ),
    );

    /// RESET TOTAL
    setState(() {
      ordemController.clear();
      quantidade = 0;
      meta = 0;
    });
  }

  Future<void> pedirMeta() async {
    final controller = TextEditingController();

    final result = await showDialog<int>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceRaised,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text('Quantidade da OF', style: AppText.title.copyWith(fontSize: 18)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: AppText.body,
            decoration: appInputDecoration(label: 'Quantidade', hint: 'Ex: 200'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: AppText.label),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null && value > 0) {
                  Navigator.pop(context, value);
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        meta = result;
        quantidade = 1;
      });
    }
  }

  void adicionar() async {
    if (meta == 0) {
      await pedirMeta();
      return;
    }

    if (quantidade >= meta) return;

    setState(() => quantidade++);
  }

  void remover() {
    if (quantidade > 0) {
      setState(() => quantidade--);
    }
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

                    const SizedBox(height: 20),

                    /// OF
                    AppCard(
                      child: TextField(
                        controller: ordemController,
                        keyboardType: TextInputType.number,
                        maxLength: 9,
                        style: AppText.body,
                        decoration: appInputDecoration(
                          label: 'Ordem (OF)',
                          icon: Icons.qr_code_2_outlined,
                          counterText: '',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// CONTADOR
                    DigitalCounterPanel(quantidade: quantidade, meta: meta),

                    const SizedBox(height: 20),

                    /// BOTÕES
                    Row(
                      children: [
                        Expanded(
                          child: TactileIconButton(
                            icon: Icons.remove,
                            color: AppColors.danger,
                            onTap: remover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TactileIconButton(
                            icon: Icons.add,
                            color: AppColors.primary,
                            onTap: adicionar,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// BOTÃO
                    PrimaryButton(
                      label: 'CONFIRMAR',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: continuar,
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