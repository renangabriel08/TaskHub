import 'dart:ui';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Como usar:
//  Scaffold(
//    appBar: const TaskHubAppBar(title: 'Título'),
//    body: ...,
//  )
// ─────────────────────────────────────────────

class TaskHubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final VoidCallback? onNotificationTap;

  const TaskHubAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Stack(
        children: [
          // ── Gradiente de fundo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF0A3D8F),
                  Color(0xFF1565C0),
                  Color(0xFF0D47A1),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Círculo decorativo superior direito
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          // ── Círculo decorativo inferior esquerdo
          Positioned(
            bottom: -40,
            left: 40,
            child: Container(
              width: 160,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // ── Conteúdo da AppBar
          SafeArea(
            bottom: false,
            child: SizedBox(
              height: 72,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Botão de voltar (se necessário)
                    if (showBackButton)
                      Row(
                        children: [
                          _AppBarIconButton(
                            icon: Icons.arrow_back,
                            onTap:
                                onBackPressed ??
                                () => Navigator.of(context).pop(),
                          ),
                          Container(width: 16),
                        ],
                      ),

                    // Título do app
                    Expanded(child: _TitleArea(title: title)),

                    // Ações customizadas (se fornecidas)
                    if (actions != null) ...[
                      ...actions!,
                      const SizedBox(width: 8),
                    ],

                    // Botão de notificação (se fornecido)
                    if (onNotificationTap != null)
                      _NotificationButton(onTap: onNotificationTap),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Área de título ────────────────────────────
class _TitleArea extends StatelessWidget {
  final String title;

  const _TitleArea({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TASKHUB',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.55),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.3,
            height: 1.0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ─── Botão de notificação ──────────
class _NotificationButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _NotificationButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Botão genérico (glassmorphism) ──────────
class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _AppBarIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
