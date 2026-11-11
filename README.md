# Financiera App

App móvil Flutter para gestión de usuarios y roles con seguridad de nivel bancario, conectada a un backend Feathers.js.

## Funcionalidades

| Área | Descripción |
| --- | --- |
| Login en dos pasos | Correo y contraseña, seguido de un código OTP enviado por correo. |
| Biometría | Ingreso con huella (Android) o Face ID (iOS) una vez activado desde la app. |
| Sesión única | Si el usuario inicia sesión en otro dispositivo, la sesión anterior se cierra automáticamente. |
| Refresh automático | Ante un `401` con `TOKEN_EXPIRED`, el access token se renueva de forma transparente y la petición se reintenta. |
| Cierre de sesión remoto | Un administrador puede cerrar la sesión de un usuario en todos sus dispositivos y, opcionalmente, revocar su ingreso biométrico. |
| Cierre por inactividad | La sesión se cierra tras 10 minutos sin actividad. |
| Tiempo real | Listas de usuarios, roles y permisos propios se actualizan al instante mediante Socket.io. |
| Usuarios | Listado paginado con búsqueda, creación, edición, asignación de rol y activación/desactivación. |
| Roles y permisos | Creación, edición y eliminación de roles con permisos granulares y dependencias entre permisos. |
| Contraseña temporal | Los usuarios con contraseña temporal son redirigidos obligatoriamente a cambiarla antes de entrar. |

### Permisos

| Permiso | Descripción |
| --- | --- |
| `users.read` | Ver usuarios |
| `users.create` | Crear usuarios |
| `users.update` | Editar usuarios |
| `users.disable` | Activar o desactivar usuarios |
| `roles.read` | Ver roles |
| `roles.create` | Crear roles |
| `roles.update` | Editar roles |
| `roles.delete` | Eliminar roles |
| `sessions.revoke` | Cerrar sesiones |

## Tecnologías

| Tecnología | Versión | Uso |
| --- | --- | --- |
| Flutter | >= 3.44.0 | Framework de UI |
| Dart | ^3.13.7 | Lenguaje |
| [get](https://pub.dev/packages/get) | ^4.7.3 | Estado, rutas e inyección de dependencias |
| [socket_io_client](https://pub.dev/packages/socket_io_client) | 1.0.2 | Eventos en tiempo real |
| [local_auth](https://pub.dev/packages/local_auth) | ^3.0.2 | Huella y Face ID |
| [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) | ^11.2.0 | Almacenamiento seguro (Keystore / Keychain) |
| [http](https://pub.dev/packages/http) | ^1.6.0 | Cliente REST |

En iOS las dependencias nativas se resuelven con Swift Package Manager (sin CocoaPods).

## Arquitectura

Patrón GetX organizado por módulos.

```
lib/
├── main.dart
└── app/
    ├── bindings/          initial_binding.dart
    ├── controllers/       auth_controller.dart
    ├── core/              api_client.dart, realtime.dart, base_controller.dart,
    │                      app_exception.dart, endpoints.dart, config.dart,
    │                      messages.dart, app_theme.dart
    ├── data/
    │   ├── datasources/   remote_datasource.dart, local_datasource.dart
    │   ├── models/        user_model.dart, role_model.dart, permissions.dart,
    │   │                  paged_result.dart
    │   └── repositories/  app_repository.dart
    ├── middlewares/       auth_middleware.dart, guest_middleware.dart
    ├── modules/
    │   ├── login/             bindings, controllers, states, views, widgets
    │   ├── change_password/   bindings, controllers, views
    │   ├── home/              bindings, controllers, states, views
    │   ├── users/             bindings, controllers, states, views, widgets
    │   └── roles/             bindings, controllers, states, views, widgets
    ├── routes/            app_pages.dart, app_routes.dart
    ├── states/            auth_state.dart
    └── widgets/           common_widgets.dart, password_field.dart
```

### Flujo de datos

```
View ──> Controller (+ State) ──> AppRepository ──┬──> RemoteDataSource ──> ApiClient (HTTP) / Realtime (Socket.io) ──> Backend
                                                  └──> LocalDataSource  ──> flutter_secure_storage / local_auth
```

| Pieza | Responsabilidad |
| --- | --- |
| Bindings | Registran las dependencias de cada módulo; `InitialBinding` crea los servicios globales y el `AuthController` permanente. |
| Middlewares | `AuthMiddleware` exige sesión y fuerza el cambio de contraseña temporal; `GuestMiddleware` impide volver al login con sesión activa. |
| State | Clases con valores reactivos (`Rx`) separadas del controlador para mantener la vista desacoplada. |
| BaseController | Método `run()` que centraliza el estado de carga, la captura de errores y los mensajes al usuario. |
| AppException | Error único de la app con mensaje, código HTTP y código de razón del backend. |
| AppRepository | Repositorio genérico CRUD (`list`, `get`, `create`, `update`, `remove`) más las operaciones de autenticación y biometría. |
| RemoteDataSource | Acceso al backend vía REST y suscripción a eventos de Socket.io. |
| LocalDataSource | Almacenamiento seguro del dispositivo y autenticación biométrica. |

## Seguridad

- **Tokens en memoria:** el access token y el refresh token viven solo en memoria y nunca se escriben en disco.
- **deviceToken protegido:** el token que habilita el ingreso biométrico se guarda en Android Keystore / iOS Keychain mediante `flutter_secure_storage`.
- **Rotación de tokens:** cada refresh entrega un nuevo par de tokens y cada ingreso biométrico reemplaza el `deviceToken` por uno nuevo. Las renovaciones concurrentes se agrupan en una sola petición.
- **Dos factores:** el acceso requiere contraseña + OTP por correo, o dispositivo registrado + biometría.
- **Revocación inmediata:** las sesiones revocadas o inválidas (`TOKEN_INVALID`, `SESSION_REVOKED`) cierran la sesión al instante a través del socket.

## Requisitos y ejecución

- Flutter SDK 3.44.0 o superior
- Backend Feathers.js en ejecución

```bash
flutter pub get
flutter run --dart-define=API_URL=http://<host>:3030
```

Si no se define `API_URL`, la app usa `http://10.0.2.2:3030`, que en el emulador de Android apunta al `localhost` de la máquina anfitriona. En un dispositivo físico, indica la dirección del backend en la red local.

## Compilación iOS sin Mac

El archivo `codemagic.yaml` define el workflow `ios-unsigned`, que compila la app en [Codemagic](https://codemagic.io) sin firma de código:

1. Conecta el repositorio en Codemagic y ejecuta el workflow `ios-unsigned`.
2. Ajusta la variable `API_URL` del workflow con la dirección de tu backend.
3. Descarga el artefacto `financiera.ipa` generado.
4. Instálalo en el iPhone con [Sideloadly](https://sideloadly.io), que firma la IPA con tu Apple ID.

```bash
flutter build ios --release --no-codesign --dart-define=API_URL=$API_URL
```

## Backend

Requiere el backend Feathers.js con MySQL y MongoDB.

## Autor

Aaron Tenen
