import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Fundo em gradiente sutil usado em todas as telas.
class IndustrialBackground extends StatelessWidget {
  final Widget child;
  const IndustrialBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bg, AppColors.bgGradientEnd],
        ),
      ),
      child: child,
    );
  }
}

/// Cartão padrão com borda sutil e sombra suave.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Botão de ação primário com gradiente.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final IconData? icon;
  final Color colorStart;
  final Color colorEnd;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 62,
    this.icon,
    this.colorStart = AppColors.primary,
    this.colorEnd = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: enabled
                ? [colorStart, colorEnd]
                : [AppColors.surfaceRaised, AppColors.surfaceRaised],
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: colorStart.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon,
                        color: enabled ? Colors.white : AppColors.textMuted,
                        size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: AppText.button.copyWith(
                      color: enabled ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botão quadrado grande para +/-, com resposta tátil.
class TactileIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const TactileIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return AspectRatio(
      aspectRatio: 1.4,
      child: Material(
        color: enabled ? color : AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: enabled
                    ? Colors.white.withOpacity(0.12)
                    : AppColors.border,
              ),
            ),
            child: Icon(
              icon,
              size: 36,
              color: enabled ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// Painel de contador mecânico — elemento assinatura do app.
class DigitalCounterPanel extends StatelessWidget {
  final int quantidade;
  final int meta;

  const DigitalCounterPanel({
    super.key,
    required this.quantidade,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    final atingiu = meta > 0 && quantidade >= meta;
    final progresso = meta > 0 ? (quantidade / meta).clamp(0.0, 1.0) : 0.0;
    final corDigitos = atingiu ? AppColors.success : AppColors.amber;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceSunken,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        children: [
          // Janela do contador, como um mostrador mecânico
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Center(
              child: Text(
                quantidade.toString().padLeft(4, '0'),
                style: AppText.counter.copyWith(
                  color: corDigitos,
                  shadows: [
                    Shadow(color: corDigitos.withOpacity(0.55), blurRadius: 18),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (meta > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('META $meta', style: AppText.eyebrow),
                Text(
                  atingiu ? 'META ATINGIDA' : 'FALTAM ${meta - quantidade}',
                  style: AppText.eyebrow.copyWith(
                    color: atingiu ? AppColors.success : AppColors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progresso,
                minHeight: 8,
                backgroundColor: AppColors.surfaceRaised,
                color: corDigitos,
              ),
            ),
          ] else
            Text('TOQUE EM + PARA INICIAR', style: AppText.eyebrow),
        ],
      ),
    );
  }
}

/// Crachá do operador exibido no topo das telas de fluxo.
class OperatorBadge extends StatelessWidget {
  final String nome;
  final String setor;

  const OperatorBadge({super.key, required this.nome, required this.setor});

  @override
  Widget build(BuildContext context) {
    final inicial = nome.isNotEmpty ? nome[0].toUpperCase() : '?';
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                inicial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.title.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 2),
                Text(
                  setor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.eyebrow,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista de opções estilizada usada nos campos com Autocomplete.
class StyledOptionsList<T extends Object> extends StatelessWidget {
  final Iterable<T> options;
  final String Function(T) labelOf;
  final void Function(T) onSelected;

  const StyledOptionsList({
    super.key,
    required this.options,
    required this.labelOf,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(14),
      color: AppColors.surfaceRaised,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        constraints: const BoxConstraints(maxHeight: 260),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          shrinkWrap: true,
          itemCount: options.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.border),
          itemBuilder: (context, index) {
            final option = options.elementAt(index);
            return ListTile(
              title: Text(labelOf(option),
                  style: AppText.body, overflow: TextOverflow.ellipsis),
              onTap: () => onSelected(option),
            );
          },
        ),
      ),
    );
  }
}