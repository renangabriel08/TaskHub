import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskhub/providers/auth_provider.dart';

class TaskHubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onNotificationTap;

  const TaskHubAppBar({
    super.key,
    this.showBackButton = false,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoggedIn = authProvider.isAuthenticated;

    return PreferredSize(
      preferredSize: preferredSize,
      child: Stack(
        children: [
          // Gradiente de fundo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF1565C0),
                  Color(0xFF0D47A1),
                  Color(0xFF0A3D8F),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Círculo decorativo superior direito
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

          // Círculo decorativo inferior esquerdo
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

          // Conteúdo da AppBar
          SafeArea(
            bottom: false,
            child: SizedBox(
              height: 72,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Botão de voltar
                    if (showBackButton)
                      Row(
                        children: [
                          _AppBarIconButton(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),

                    // Logo/Título
                    const Expanded(child: _TaskHubLogo()),

                    // Botões direitos (dinâmicos baseado em autenticação)
                    if (isLoggedIn) ...[
                      _NotificationButton(onTap: onNotificationTap),
                      const SizedBox(width: 8),
                      _AppBarIconButton(
                        icon: Icons.logout,
                        onTap: () => authProvider.logout(),
                      ),
                    ] else ...[
                      _AppBarTextButton(
                        label: 'Login',
                        onTap: () => Navigator.of(context).pushNamed('/login'),
                      ),
                      const SizedBox(width: 8),
                      _AppBarTextButton(
                        label: 'Cadastro',
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed('/register-user-type'),
                      ),
                    ],
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

// ─── Logo/Título do TaskHub ───────────────────
class _TaskHubLogo extends StatelessWidget {
  const _TaskHubLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PLATAFORMA DE SERVIÇOS',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.55),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'TaskHub',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.3,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

// ─── Botão de Notificação ──────────
class _NotificationButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _NotificationButton({this.onTap});

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
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Botão de Ícone (Glassmorphism) ────────────
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

// ─── Botão de Texto (Login/Cadastro) ────────────
class _AppBarTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _AppBarTextButton({required this.label, this.onTap});

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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
