import 'package:flutter/material.dart';
import 'package:taskhub/config/app_colors.dart';
import 'package:taskhub/widgets/app_bar_widget.dart';

class RegisterTypeSelectionScreen extends StatelessWidget {
  const RegisterTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TaskHubAppBar(title: 'Cadastro', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qual tipo de conta deseja criar?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Escolha o tipo de conta que melhor representa você',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            // Client Option
            _RegisterTypeCard(
              icon: Icons.person_search,
              title: 'Cliente',
              description: 'Procurando serviços',
              onTap: () {
                Navigator.of(context).pushNamed('/register/client');
              },
            ),
            const SizedBox(height: 16),
            // Professional Option
            _RegisterTypeCard(
              icon: Icons.person_pin,
              title: 'Prestador Autônomo',
              description: 'Oferecendo serviços (Pessoa Física)',
              onTap: () {
                Navigator.of(context).pushNamed('/register/professional');
              },
            ),
            const SizedBox(height: 16),
            // Company Option
            _RegisterTypeCard(
              icon: Icons.business,
              title: 'Empresa Prestadora',
              description: 'Oferecendo serviços (Pessoa Jurídica)',
              onTap: () {
                Navigator.of(context).pushNamed('/register/company');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RegisterTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryVeryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
