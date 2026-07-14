import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'production_screen.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class OrderInputScreen extends StatefulWidget {
  final String setor;
  final String funcionario;
  final String funcionarioId;

  const OrderInputScreen({
    super.key,
    required this.setor,
    required this.funcionario,
    required this.funcionarioId,
  });

  @override
  State<OrderInputScreen> createState() => _OrderInputScreenState();
}

class _OrderInputScreenState extends State<OrderInputScreen> {
  final ordemController        = TextEditingController();
  final codigoProdutoController = TextEditingController();
  final metaController         = TextEditingController();

  void continuar() {
    final ordem          = ordemController.text.trim();
    final codigoProduto  = codigoProdutoController.text.trim();
    final meta           = int.tryParse(metaController.text);

    if (ordem.isEmpty) {
      _erro('Informe a OF');
      return;
    }

    if (codigoProduto.isEmpty) {
      _erro('Informe o Código do Produto');
      return;
    }

    if (meta == null || meta <= 0) {
      _erro('A Produzir deve ser maior que 0');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductionScreen(
          setor: widget.setor,
          funcionario: widget.funcionario,
          funcionarioId: widget.funcionarioId,
          ordem: ordem,
          codigoProduto: codigoProduto,
          meta: meta,
        ),
      ),
    );
  }

  void _erro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
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
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                width: largura > 600 ? 480 : double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// LOGO
                    SizedBox(
                      height: 120,
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// CRACHÁ DO OPERADOR
                    OperatorBadge(nome: widget.funcionario, setor: widget.setor),

                    const SizedBox(height: 24),

                    /// CARD
                    AppCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.assignment_outlined,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Iniciar Produção',
                                style: AppText.title.copyWith(fontSize: 18),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          /// OF
                          TextField(
                            controller: ordemController,
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                            style: AppText.body,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: appInputDecoration(
                              label: 'Ordem de Fabricação (OF)',
                              hint: 'Ex: 00143174',
                              icon: Icons.qr_code_2_outlined,
                              counterText: '',
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// CÓDIGO DO PRODUTO
                          TextField(
                            controller: codigoProdutoController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            style: AppText.body,
                            decoration: appInputDecoration(
                              label: 'Código do Produto',
                              hint: 'Ex: ABC-1234',
                              icon: Icons.inventory_2_outlined,
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// META
                          TextField(
                            controller: metaController,
                            keyboardType: TextInputType.number,
                            style: AppText.body,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: appInputDecoration(
                              label: 'A Produzir',
                              hint: 'Ex: 200',
                              icon: Icons.flag_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// BOTÃO
                    PrimaryButton(
                      label: 'INICIAR',
                      icon: Icons.play_arrow_rounded,
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
