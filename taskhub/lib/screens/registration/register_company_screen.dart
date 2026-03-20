import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskhub/config/app_colors.dart';
import 'package:taskhub/providers/auth_provider.dart';
import 'package:taskhub/widgets/app_bar_widget.dart';
import 'package:taskhub/utils/validation_helper.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  late TextEditingController _companyNameController;
  late TextEditingController _cnpjController;
  late TextEditingController _responsibleNameController;
  late TextEditingController _responsibleCpfController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _cepController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _streetController;
  late TextEditingController _numberController;
  late TextEditingController _descriptionController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController();
    _cnpjController = TextEditingController();
    _responsibleNameController = TextEditingController();
    _responsibleCpfController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _cepController = TextEditingController();
    _stateController = TextEditingController();
    _cityController = TextEditingController();
    _neighborhoodController = TextEditingController();
    _streetController = TextEditingController();
    _numberController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _cnpjController.dispose();
    _responsibleNameController.dispose();
    _responsibleCpfController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cepController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: const TaskHubAppBar(
        title: 'Cadastro - Empresa',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'Dados da Empresa'),
                const SizedBox(height: 16),
                // Company Name
                TextFormField(
                  controller: _companyNameController,
                  decoration: _inputDecoration(
                    'Razão Social *',
                    Icons.business,
                  ),
                ),
                const SizedBox(height: 12),
                // CNPJ
                TextFormField(
                  controller: _cnpjController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _cnpjController.text = InputMask.formatCNPJ(value);
                    _cnpjController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _cnpjController.text.length),
                    );
                  },
                  decoration: _inputDecoration('CNPJ *', Icons.credit_card),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Responsável pela Conta'),
                const SizedBox(height: 16),
                // Responsible Name
                TextFormField(
                  controller: _responsibleNameController,
                  decoration: _inputDecoration(
                    'Nome do Responsável *',
                    Icons.person,
                  ),
                ),
                const SizedBox(height: 12),
                // Responsible CPF
                TextFormField(
                  controller: _responsibleCpfController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _responsibleCpfController.text = InputMask.formatCPF(value);
                    _responsibleCpfController.selection =
                        TextSelection.fromPosition(
                          TextPosition(
                            offset: _responsibleCpfController.text.length,
                          ),
                        );
                  },
                  decoration: _inputDecoration('CPF do Responsável *', null),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Contato'),
                const SizedBox(height: 16),
                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Email *', Icons.email_outlined),
                ),
                const SizedBox(height: 12),
                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    _phoneController.text = InputMask.formatPhone(value);
                    _phoneController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _phoneController.text.length),
                    );
                  },
                  decoration: _inputDecoration(
                    'Telefone',
                    Icons.phone_outlined,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Endereço'),
                const SizedBox(height: 16),
                // CEP
                TextFormField(
                  controller: _cepController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _cepController.text = InputMask.formatCEP(value);
                    _cepController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _cepController.text.length),
                    );
                  },
                  decoration: _inputDecoration(
                    'CEP',
                    Icons.location_on_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                // State and City
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _stateController,
                        decoration: _smallInputDecoration('Estado'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _cityController,
                        decoration: _smallInputDecoration('Cidade'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Neighborhood
                TextFormField(
                  controller: _neighborhoodController,
                  decoration: _inputDecoration('Bairro', null),
                ),
                const SizedBox(height: 12),
                // Street
                TextFormField(
                  controller: _streetController,
                  decoration: _inputDecoration('Rua', null),
                ),
                const SizedBox(height: 12),
                // Number
                TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Número', null),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Informações da Empresa'),
                const SizedBox(height: 16),
                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration('Descrição da Empresa', null),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Segurança'),
                const SizedBox(height: 16),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Senha *',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => ValidationHelper.validatePasswordMatch(
                    value,
                    _passwordController.text,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Confirmar Senha *',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Terms Checkbox
                CheckboxListTile(
                  value: _agreeTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeTerms = value ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                  title: const Text(
                    'Aceito os termos de uso e regras da plataforma',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 24),
                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textInverse,
                              ),
                            ),
                          )
                        : const Text(
                            'Cadastrar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textInverse,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem conta? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text(
                        'Faça login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  InputDecoration _smallInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
