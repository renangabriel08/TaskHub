import 'package:flutter/material.dart';
import 'package:taskhub/config/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight.withOpacity(0.2),
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'João Silva',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cliente',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryVeryLight, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Email', 'joao.silva@email.com'),
                const SizedBox(height: 12),
                _buildInfoRow('Telefone', '(11) 99999-9999'),
                const SizedBox(height: 12),
                _buildInfoRow('CPF', '123.456.789-00'),
                const SizedBox(height: 12),
                _buildInfoRow('Data de Nascimento', '15/03/1990'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Options Menu
          _buildMenuSection(
            context,
            icon: Icons.edit_outlined,
            title: 'Editar Perfil',
            subtitle: 'Atualize seus dados pessoais',
            onTap: () {},
          ),
          _buildMenuSection(
            context,
            icon: Icons.history,
            title: 'Histórico de Serviços',
            subtitle: 'Veja seus pedidos anteriores',
            onTap: () {},
          ),
          _buildMenuSection(
            context,
            icon: Icons.star_outline,
            title: 'Avaliações',
            subtitle: 'Suas classificações e comentários',
            onTap: () {},
          ),
          _buildMenuSection(
            context,
            icon: Icons.bookmark_outline,
            title: 'Favoritos',
            subtitle: 'Serviços e profissionais salvos',
            onTap: () {},
          ),
          _buildMenuSection(
            context,
            icon: Icons.settings_outlined,
            title: 'Configurações',
            subtitle: 'Privacidade e preferências',
            onTap: () {},
          ),
          _buildMenuSection(
            context,
            icon: Icons.help_outline,
            title: 'Suporte',
            subtitle: 'Dúvidas e problemas',
            onTap: () {},
          ),
          _buildMenuSection(
            context,
            icon: Icons.logout,
            title: 'Sair',
            subtitle: 'Desconectar da sua conta',
            onTap: () {
              _showLogoutConfirmation(context);
            },
            isRed: true,
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  static Widget _buildMenuSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isRed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryVeryLight, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRed
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.primaryVeryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isRed ? AppColors.error : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  static void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja desconectar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar logout
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Sair', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
