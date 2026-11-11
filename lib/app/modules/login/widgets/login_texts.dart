class LoginTexts {
  LoginTexts._();

  static const appName = 'Financiera';
  static const appVersion = String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');
  static const goodMorning = 'Buenos días';
  static const goodAfternoon = 'Buenas tardes';
  static const goodEvening = 'Buenas noches';
  static const credentialsSubtitle = 'Ingresa tus datos para continuar';
  static const otpTitle = 'Verificación de seguridad';
  static const otpSentTo = 'Ingresa el código de 6 dígitos que enviamos a';
  static const otpExpiresIn = 'El código vence en';
  static const otpExpired = 'El código venció. Vuelve para solicitar uno nuevo.';
  static const verify = 'Verificar';
  static const back = 'Volver';
  static const secureConnection = 'Conexión segura';

  static String greeting(DateTime now) {
    if (now.hour >= 5 && now.hour < 12) return goodMorning;
    if (now.hour >= 12 && now.hour < 19) return goodAfternoon;
    return goodEvening;
  }

  static String maskEmail(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return email;
    final local = email.substring(0, at);
    final visible = local.length <= 2 ? local.substring(0, 1) : local.substring(0, 2);
    return '$visible***${email.substring(at)}';
  }
}
