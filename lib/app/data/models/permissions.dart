const permissionLabels = <String, String>{
  'users.read': 'Ver usuarios',
  'users.create': 'Crear usuarios',
  'users.update': 'Editar usuarios',
  'users.disable': 'Activar o desactivar usuarios',
  'roles.read': 'Ver roles',
  'roles.create': 'Crear roles',
  'roles.update': 'Editar roles',
  'roles.delete': 'Eliminar roles',
  'sessions.revoke': 'Cerrar sesiones',
};

const permissionDependencies = <String, List<String>>{
  'users.create': ['users.read'],
  'users.update': ['users.read'],
  'users.disable': ['users.read'],
  'roles.create': ['roles.read'],
  'roles.update': ['roles.read'],
  'roles.delete': ['roles.read'],
  'sessions.revoke': ['users.read'],
};
