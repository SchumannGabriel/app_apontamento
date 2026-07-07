import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_input_screen.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? setorSelecionado;
  String? funcionarioId;
  String? funcionarioNome;

  final setores = [
    'Acabamento Flange',
    'Calandra',
    'Corte (laser)',
    'Descarregamento Pintura',
    'Escarear',
    'Frisadeira',
    'Furar válvula',
    'Jato de Granalha',
    'Lixa Emenda Anel',
    'Ponteação',
    'Prensa',
    'Retifica',
    'Solda',
    'Solda Emenda Anel',
    'Suspensão',
    'Teste LP',
    'Usinagem',
  ];

  void entrar() {
    if (setorSelecionado != null && funcionarioId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderInputScreen(
            setor: setorSelecionado!,
            funcionario: funcionarioNome!,
            funcionarioId: funcionarioId!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final podeEntrar = setorSelecionado != null && funcionarioId != null;

    return Scaffold(
      body: IndustrialBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Container(
                width: largura > 600 ? 480 : double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    ///  LOGO
                    SizedBox(
                      height: 150,
                      child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                    ),

                    const SizedBox(height: 10),

                    Text('CONTROLE DE CHÃO DE FÁBRICA', style: AppText.eyebrow),

                    const SizedBox(height: 6),

                    Text(
                      'Apontamento de Produção',
                      textAlign: TextAlign.center,
                      style: AppText.title.copyWith(fontSize: 26),
                    ),

                    const SizedBox(height: 32),

                    AppCard(
                      child: Column(
                        children: [
                          ///  SETOR COM BUSCA
                          Autocomplete<String>(
                            optionsBuilder: (text) {
                              if (text.text.isEmpty) return setores;

                              return setores.where(
                                (s) => s.toLowerCase().contains(text.text.toLowerCase()),
                              );
                            },

                            onSelected: (value) {
                              setState(() => setorSelecionado = value);
                            },

                            fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: AppText.body,
                                decoration: appInputDecoration(
                                  label: 'Setor',
                                  icon: Icons.factory_outlined,
                                ),
                              );
                            },

                            optionsViewBuilder: (context, onSelected, options) {
                              return StyledOptionsList<String>(
                                options: options,
                                labelOf: (s) => s,
                                onSelected: onSelected,
                              );
                            },
                          ),

                          const SizedBox(height: 18),

                          ///  FUNCIONÁRIO COM BUSCA
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('funcionarios')
                                .where('ativo', isEqualTo: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                );
                              }

                              final docs = snapshot.data!.docs;

                              return Autocomplete<QueryDocumentSnapshot>(
                                optionsBuilder: (text) {
                                  if (text.text.isEmpty) return docs;

                                  return docs.where(
                                    (doc) => doc['nome']
                                        .toString()
                                        .toLowerCase()
                                        .contains(text.text.toLowerCase()),
                                  );
                                },

                                displayStringForOption: (doc) => doc['nome'],

                                onSelected: (doc) {
                                  setState(() {
                                    funcionarioId = doc.id;
                                    funcionarioNome = doc['nome'];
                                  });
                                },

                                fieldViewBuilder:
                                    (context, controller, focusNode, onSubmit) {
                                      return TextField(
                                        controller: controller,
                                        focusNode: focusNode,
                                        style: AppText.body,
                                        decoration: appInputDecoration(
                                          label: 'Funcionário',
                                          icon: Icons.badge_outlined,
                                        ),
                                      );
                                    },

                                optionsViewBuilder: (context, onSelected, options) {
                                  return StyledOptionsList<QueryDocumentSnapshot>(
                                    options: options,
                                    labelOf: (doc) => doc['nome'],
                                    onSelected: onSelected,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    ///  BOTÃO
                    PrimaryButton(
                      label: 'ENTRAR',
                      icon: Icons.login_rounded,
                      onPressed: podeEntrar ? entrar : null,
                    ),

                    const SizedBox(height: 14),

                    ///  VALIDAÇÃO
                    if (!podeEntrar)
                      Text(
                        'Selecione setor e funcionário',
                        style: AppText.label.copyWith(color: AppColors.danger),
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