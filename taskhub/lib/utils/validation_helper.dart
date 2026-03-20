class ValidationHelper {
  // Email Validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!isValidEmail(value)) {
      return 'Email inválido';
    }
    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres';
    }
    return null;
  }

  static String? validatePasswordMatch(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != password) {
      return 'As senhas não conferem';
    }
    return null;
  }

  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.length < 2) {
      return 'Nome deve ter no mínimo 2 caracteres';
    }
    return null;
  }

  // CPF Validation
  static bool isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11) return false;
    if (cpf == cpf[0] * 11) return false;

    int sum = 0;
    int remainder;

    for (int i = 1; i <= 9; i++) {
      sum += int.parse(cpf[i - 1]) * (11 - i);
    }

    remainder = (sum * 10) % 11;
    if (remainder == 10 || remainder == 11) remainder = 0;
    if (remainder != int.parse(cpf[9])) return false;

    sum = 0;
    for (int i = 1; i <= 10; i++) {
      sum += int.parse(cpf[i - 1]) * (12 - i);
    }

    remainder = (sum * 10) % 11;
    if (remainder == 10 || remainder == 11) remainder = 0;
    if (remainder != int.parse(cpf[10])) return false;

    return true;
  }

  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    if (!isValidCPF(value)) {
      return 'CPF inválido';
    }
    return null;
  }

  // CNPJ Validation
  static bool isValidCNPJ(String cnpj) {
    cnpj = cnpj.replaceAll(RegExp(r'\D'), '');
    if (cnpj.length != 14) return false;
    if (cnpj == cnpj[0] * 14) return false;

    int sum = 0;
    int remainder;
    final List<int> firstMultiplier = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    for (int i = 0; i < 12; i++) {
      sum += int.parse(cnpj[i]) * firstMultiplier[i];
    }

    remainder = (sum % 11) < 2 ? 0 : 11 - (sum % 11);
    if (remainder != int.parse(cnpj[12])) return false;

    sum = 0;
    final List<int> secondMultiplier = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    for (int i = 0; i < 13; i++) {
      sum += int.parse(cnpj[i]) * secondMultiplier[i];
    }

    remainder = (sum % 11) < 2 ? 0 : 11 - (sum % 11);
    if (remainder != int.parse(cnpj[13])) return false;

    return true;
  }

  static String? validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }
    if (!isValidCNPJ(value)) {
      return 'CNPJ inválido';
    }
    return null;
  }

  // Phone Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    final phoneRegex = RegExp(r'^(\+\d{1,3})?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\D'), ''))) {
      return 'Telefone inválido';
    }
    return null;
  }

  // CEP Validation
  static String? validateCEP(String? value) {
    if (value == null || value.isEmpty) {
      return null; // CEP is optional
    }
    final cepRegex = RegExp(r'^\d{5}-?\d{3}$');
    if (!cepRegex.hasMatch(value)) {
      return 'CEP inválido (formato: 00000-000)';
    }
    return null;
  }

  // Text field validation (generic)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }
}

class InputMask {
  // Format CPF: XXX.XXX.XXX-XX
  static String formatCPF(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');
    if (value.length > 11) value = value.substring(0, 11);
    if (value.length > 9) {
      return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6, 9)}-${value.substring(9)}';
    } else if (value.length > 6) {
      return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6)}';
    } else if (value.length > 3) {
      return '${value.substring(0, 3)}.${value.substring(3)}';
    }
    return value;
  }

  // Format CNPJ: XX.XXX.XXX/XXXX-XX
  static String formatCNPJ(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');
    if (value.length > 14) value = value.substring(0, 14);
    if (value.length > 12) {
      return '${value.substring(0, 2)}.${value.substring(2, 5)}.${value.substring(5, 8)}//${value.substring(8, 12)}-${value.substring(12)}';
    } else if (value.length > 8) {
      return '${value.substring(0, 2)}.${value.substring(2, 5)}.${value.substring(5, 8)}//${value.substring(8)}';
    } else if (value.length > 5) {
      return '${value.substring(0, 2)}.${value.substring(2, 5)}.${value.substring(5)}';
    } else if (value.length > 2) {
      return '${value.substring(0, 2)}.${value.substring(2)}';
    }
    return value;
  }

  // Format Phone: (XX) XXXXX-XXXX or (XX) XXXX-XXXX
  static String formatPhone(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');
    if (value.length > 11) value = value.substring(0, 11);
    if (value.length > 7) {
      return '(${value.substring(0, 2)}) ${value.substring(2, 7)}-${value.substring(7)}';
    } else if (value.length > 2) {
      return '(${value.substring(0, 2)}) ${value.substring(2)}';
    }
    return value;
  }

  // Format CEP: XXXXX-XXX
  static String formatCEP(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');
    if (value.length > 8) value = value.substring(0, 8);
    if (value.length > 5) {
      return '${value.substring(0, 5)}-${value.substring(5)}';
    }
    return value;
  }

  // Format RG: XX.XXX.XXX-X
  static String formatRG(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');
    if (value.length > 9) value = value.substring(0, 9);
    if (value.length > 8) {
      return '${value.substring(0, 2)}.${value.substring(2, 5)}.${value.substring(5, 8)}-${value.substring(8)}';
    } else if (value.length > 5) {
      return '${value.substring(0, 2)}.${value.substring(2, 5)}.${value.substring(5)}';
    } else if (value.length > 2) {
      return '${value.substring(0, 2)}.${value.substring(2)}';
    }
    return value;
  }
}
