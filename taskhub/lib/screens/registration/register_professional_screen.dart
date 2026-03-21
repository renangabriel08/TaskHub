import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taskhub/config/app_colors.dart';
import 'package:taskhub/providers/auth_provider.dart';
import 'package:taskhub/utils/validation_helper.dart';
import 'package:taskhub/widgets/app_bar_widget.dart';

class RegisterProfessionalScreen extends StatefulWidget {
  const RegisterProfessionalScreen({super.key});

  @override
  State<RegisterProfessionalScreen> createState() =>
      _RegisterProfessionalScreenState();
}

class _RegisterProfessionalScreenState
    extends State<RegisterProfessionalScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _cpfController;
  late TextEditingController _birthDateController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late TextEditingController _cepController;
  late TextEditingController _streetController;
  late TextEditingController _numberController;
  late TextEditingController _complementController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;

  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _isLoadingCEP = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _cpfController = TextEditingController();
    _birthDateController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _cepController = TextEditingController();
    _streetController = TextEditingController();
    _numberController = TextEditingController();
    _complementController = TextEditingController();
    _neighborhoodController = TextEditingController();
    _stateController = TextEditingController();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _cpfController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      _showErrorSnackBar('Aceite os termos para continuar');
      return;
    }

    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _fetchAddressFromCEP(String cep) async {
    if (cep.length != 8) return;

    setState(() => _isLoadingCEP = true);

    try {
      final response = await http
          .get(Uri.parse('https://viacep.com.br/ws/$cep/json/'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['erro'] != true) {
          setState(() {
            _streetController.text = data['logradouro'] ?? '';
            _neighborhoodController.text = data['bairro'] ?? '';
            _cityController.text = data['localidade'] ?? '';
            _stateController.text = data['uf'] ?? '';
          });
        } else {
          _showErrorSnackBar('CEP não encontrado');
        }
      } else {
        _showErrorSnackBar('Erro ao buscar CEP');
      }
    } catch (_) {
      _showErrorSnackBar('Erro de conexão ao buscar CEP');
    } finally {
      if (mounted) {
        setState(() => _isLoadingCEP = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedFile = await _imagePicker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _profileImage = File(pickedFile.path);
                    });
                  }
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Câmera'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedFile = await _imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _profileImage = File(pickedFile.path);
                    });
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('Galeria'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: const TaskHubAppBar(
        title: 'Cadastro - Prestador Autônomo',
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
                Center(
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryVeryLight,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: _profileImage != null
                          ? ClipOval(
                              child: Image.file(
                                _profileImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 48,
                              color: AppColors.primary,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Toque para adicionar foto',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(context, 'Informações Pessoais'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  validator: (value) =>
                      ValidationHelper.validateRequired(value, 'Nome completo'),
                  decoration: _inputDecoration('Nome Completo *', Icons.person_outline),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _cpfController.text = InputMask.formatCPF(value);
                    _cpfController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _cpfController.text.length),
                    );
                  },
                  validator: ValidationHelper.validateCPF,
                  decoration: _inputDecoration('CPF *', Icons.credit_card),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _birthDateController,
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.now().subtract(const Duration(days: 365 * 18)),
                      firstDate: DateTime(1950),
                      lastDate:
                          DateTime.now().subtract(const Duration(days: 365 * 18)),
                    );
                    if (pickedDate != null) {
                      _birthDateController.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    }
                  },
                  validator: (value) => ValidationHelper.validateRequired(
                    value,
                    'Data de nascimento',
                  ),
                  decoration: _inputDecoration(
                    'Data de Nascimento *',
                    Icons.calendar_today,
                  ),
                ),
                const SizedBox(height: 16),

                _buildSectionTitle(context, 'Conta'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationHelper.validateEmail,
                  decoration: _inputDecoration('Email *', Icons.email_outlined),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    _phoneController.text = InputMask.formatPhone(value);
                    _phoneController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _phoneController.text.length),
                    );
                  },
                  validator: ValidationHelper.validatePhone,
                  decoration: _inputDecoration('Telefone', Icons.phone_outlined),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: ValidationHelper.validatePassword,
                  decoration: InputDecoration(
                    hintText: 'Senha *',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),

                _buildSectionTitle(context, 'Endereço'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cepController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _cepController.text = InputMask.formatCEP(value);
                    _cepController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _cepController.text.length),
                    );

                    final rawCep = _cepController.text.replaceAll(RegExp(r'\D'), '');
                    if (rawCep.length == 8) {
                      _fetchAddressFromCEP(rawCep);
                    }
                  },
                  validator: ValidationHelper.validateCEP,
                  decoration: InputDecoration(
                    hintText: 'CEP',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    suffix: _isLoadingCEP
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _stateController,
                        readOnly: true,
                        validator: (value) =>
                            ValidationHelper.validateRequired(value, 'Estado'),
                        decoration: _smallInputDecoration('Estado'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _cityController,
                        readOnly: true,
                        validator: (value) =>
                            ValidationHelper.validateRequired(value, 'Cidade'),
                        decoration: _smallInputDecoration('Cidade'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _neighborhoodController,
                  readOnly: true,
                  validator: (value) =>
                      ValidationHelper.validateRequired(value, 'Bairro'),
                  decoration: _inputDecoration('Bairro', null),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _streetController,
                  readOnly: true,
                  validator: (value) => ValidationHelper.validateRequired(value, 'Rua'),
                  decoration: _inputDecoration('Rua', null),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            ValidationHelper.validateRequired(value, 'Número'),
                        decoration: _smallInputDecoration('Número'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _complementController,
                        decoration: _smallInputDecoration('Complemento'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

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
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 24),

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
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.w600),
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
