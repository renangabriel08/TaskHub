import 'package:flutter/services.dart';

class InputFormatters {
  // CPF formatter (###.###.###-##)
  static TextInputFormatter getCPFFormatter() {
    return FilteringTextInputFormatter.digitsOnly;
  }

  // CNPJ formatter (##.###.###/####-##)
  static TextInputFormatter getCNPJFormatter() {
    return FilteringTextInputFormatter.digitsOnly;
  }

  // Phone formatter ((##) ####-#### or (##) #####-####)
  static TextInputFormatter getPhoneFormatter() {
    return FilteringTextInputFormatter.digitsOnly;
  }

  // CEP formatter (##.###-###)
  static TextInputFormatter getCEPFormatter() {
    return FilteringTextInputFormatter.digitsOnly;
  }

  // Digits only
  static TextInputFormatter getDigitsOnlyFormatter() {
    return FilteringTextInputFormatter.digitsOnly;
  }

  // Currency formatter
  static TextInputFormatter getCurrencyFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));
  }
}

class InputMasks {
  // Format CPF: ###.###.###-##
  static String formatCPF(String value) {
    String cpf = value.replaceAll(RegExp(r'\D'), '');
    if (cpf.isEmpty) return '';
    if (cpf.length <= 3) return cpf;
    if (cpf.length <= 6) return '${cpf.substring(0, 3)}.${cpf.substring(3)}';
    if (cpf.length <= 9) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6)}';
    }
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
  }

  // Format CNPJ: ##.###.###/####-##
  static String formatCNPJ(String value) {
    String cnpj = value.replaceAll(RegExp(r'\D'), '');
    if (cnpj.isEmpty) return '';
    if (cnpj.length <= 2) return cnpj;
    if (cnpj.length <= 5) return '${cnpj.substring(0, 2)}.${cnpj.substring(2)}';
    if (cnpj.length <= 8) {
      return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5)}';
    }
    if (cnpj.length <= 12) {
      return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8)}';
    }
    return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12, 14)}';
  }

  // Format Phone: (##) ####-#### or (##) #####-####
  static String formatPhone(String value) {
    String phone = value.replaceAll(RegExp(r'\D'), '');
    if (phone.isEmpty) return '';
    if (phone.length <= 2) return '($phone';
    if (phone.length <= 6) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2)}';
    }
    if (phone.length <= 10) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 6)}-${phone.substring(6)}';
    }
    return '(${phone.substring(0, 2)}) ${phone.substring(2, 7)}-${phone.substring(7, 11)}';
  }

  // Format CEP: ##.###-###
  static String formatCEP(String value) {
    String cep = value.replaceAll(RegExp(r'\D'), '');
    if (cep.isEmpty) return '';
    if (cep.length <= 5) return cep;
    return '${cep.substring(0, 5)}-${cep.substring(5, 8)}';
  }

  // Format Currency: Convert to Brazilian format
  static String formatCurrency(String value) {
    String currency = value.replaceAll(RegExp(r'\D'), '');
    if (currency.isEmpty) return '';
    double amount = double.parse(currency) / 100;
    return 'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Unformat values
  static String unformatValue(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }
}
