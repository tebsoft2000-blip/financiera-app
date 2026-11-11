class Messages {
  Messages._();

  static const commonAppName = 'App Tarea';
  static const commonCancel = 'Cancelar';
  static const commonDelete = 'Eliminar';
  static const commonEdit = 'Editar';
  static const commonActivate = 'Activar';
  static const commonDeactivate = 'Desactivar';
  static const commonSaving = 'Guardando…';
  static const commonSaveChanges = 'Guardar cambios';
  static const commonRetry = 'Volver a intentar';
  static const commonNotNow = 'Ahora no';
  static const commonPrevious = 'Anterior';
  static const commonNext = 'Siguiente';
  static String commonPageOf(int page, int pages) => 'Página $page de $pages';

  static const authLoginTitle = 'Ingresa a tu cuenta';
  static const authOtpTitle = 'Verifica que eres tú';
  static const authOtpLabel = 'Código de verificación';
  static const authEmail = 'Correo';
  static const authVerifying = 'Verificando…';
  static const authSignIn = 'Ingresar';
  static const authContinue = 'Continuar';
  static const authUseOtherAccount = 'Usar otra cuenta o pedir un código nuevo';
  static const authLogout = 'Salir';
  static const authSessionEnded = 'Tu sesión terminó. Si iniciaste sesión en otro lugar, esta se cerró por seguridad.';
  static const authIdleLogout = 'Cerramos tu sesión por inactividad.';
  static String authOtpSent(String email) => 'Enviamos un código de 6 dígitos a $email. Vence en 5 minutos.';

  static const biometricLogin = 'Ingresar con huella';
  static const biometricExpired = 'Tu acceso con huella venció. Ingresa con tu clave y código.';
  static const biometricConfirmLogin = 'Confirma tu huella para ingresar';
  static const biometricConfirmEnable = 'Confirma tu huella para activar el ingreso con huella';
  static const biometricEnableQuestion = '¿Activar ingreso con huella?';
  static const biometricDisable = 'Desactivar huella';

  static const usersTitle = 'Usuarios';
  static const usersNew = 'Nuevo usuario';
  static const usersEdit = 'Editar usuario';
  static const usersCreate = 'Crear usuario';
  static const usersSearchHint = 'Buscar por nombre o correo';
  static const usersLoading = 'Cargando usuarios…';
  static const usersEmpty = 'No hay usuarios que coincidan con la búsqueda.';
  static const usersForceLogout = 'Cerrar sesión';
  static const usersRevokeBiometric = 'También desactivar su ingreso con huella';
  static const usersFullName = 'Nombre completo';
  static const usersPhone = 'Teléfono';
  static const usersPhoneHint = '+593 99 123 4567';
  static const usersAddress = 'Dirección';
  static const usersRole = 'Rol';
  static const usersNoRoles = 'No tienes roles disponibles para asignar';
  static const usersTemporaryPassword = 'Se enviará una clave temporal al correo del usuario.';
  static String usersTotal(int total) => '$total usuarios registrados. Los cambios se ven al instante.';
  static String usersForceLogoutBody(String name) => 'Se cerrará la sesión de $name en todos sus dispositivos.';
  static String usersDetails(String role, bool isActive, String? phone) =>
      '$role · ${isActive ? 'Activo' : 'Inactivo'}${phone != null ? ' · $phone' : ''}';

  static const rolesTitle = 'Roles';
  static const rolesNew = 'Nuevo rol';
  static const rolesEdit = 'Editar rol';
  static const rolesCreate = 'Crear rol';
  static const rolesDelete = 'Eliminar rol';
  static const rolesLoading = 'Cargando roles…';
  static const rolesDescription = 'Cada rol define qué puede ver y hacer un usuario.';
  static const rolesProtected = 'Protegido';
  static const rolesName = 'Nombre del rol';
  static const rolesPermissions = 'Permisos';
  static const rolesGrantHint = 'Solo puedes otorgar permisos que tú tienes.';
  static const rolesNoSections = 'Tu rol no tiene permisos para ver ninguna sección.';
  static String rolesConfirmDelete(String name) => '¿Eliminar el rol $name?';
  static String rolesRequiredBy(List<String> labels) => 'Requerido por: ${labels.join(', ')}';

  static const passwordLabel = 'Clave';
  static const passwordShow = 'Mostrar clave';
  static const passwordHide = 'Ocultar clave';
  static const passwordCreateTitle = 'Crea tu nueva clave';
  static const passwordCurrent = 'Clave actual';
  static const passwordNew = 'Nueva clave';
  static const passwordRequirements = 'Mínimo 12 caracteres, con mayúscula, minúscula, número y símbolo.';
  static const passwordSave = 'Guardar clave';
  static const passwordUpdated = 'Clave actualizada. Ingresa con tu nueva clave.';

  static const errorUnexpected = 'Error inesperado';
  static const errorConnection = 'No se pudo conectar con el servidor';
}
