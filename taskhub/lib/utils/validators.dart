class Validators {
  // CPF validation
  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    // Remove non-digits
    final cpf = value.replaceAll(RegExp(r'\D'), '');

    if (cpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Check if all digits are the same
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    return null;
  }

  // CNPJ validation
  static String? validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }

    final cnpj = value.replaceAll(RegExp(r'\D'), '');

    if (cnpj.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }

    // Check if all digits are the same
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) {
      return 'CNPJ inválido';
    }

    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  // Phone validation (Brazilian format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }

    final phone = value.replaceAll(RegExp(r'\D'), '');

    if (phone.length < 10 || phone.length > 11) {
      return 'Telefone inválido';
    }

    return null;
  }

  // Optional phone validation
  static String? validatePhoneOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final phone = value.replaceAll(RegExp(r'\D'), '');

    if (phone.length < 10 || phone.length > 11) {
      return 'Telefone inválido';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }

    return null;
  }

  // Password confirmation
  static String? validatePasswordConfirmation(
    String? value,
    String? passwordValue,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != passwordValue) {
      return 'As senhas não conferem';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }

    if (value.length < 3) {
      return 'Mínimo 3 caracteres';
    }

    return null;
  }

  // Optional name validation
  static String? validateNameOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length < 3) {
      return 'Mínimo 3 caracteres';
    }

    return null;
  }

  // CEP validation (Brazilian)
  static String? validateCEP(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }

    final cep = value.replaceAll(RegExp(r'\D'), '');

    if (cep.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }

    return null;
  }

  // Number validation
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }

    if (int.tryParse(value) == null) {
      return 'Digite um número válido';
    }

    return null;
  }

  // Number validation optional
  static String? validateNumberOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (int.tryParse(value) == null) {
      return 'Digite um número válido';
    }

    return null;
  }

  // Required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  // Optional field (always returns null)
  static String? validateOptional(String? value) {
    return null;
  }

  // Date validation (basic)
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data é obrigatória';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Data inválida';
    }
  }

  // URL validation (optional)
  static String? validateUrlOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      Uri.parse(value);
      return null;
    } catch (e) {
      return 'URL inválida';
    }
  }
}
