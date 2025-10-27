# Guía de Desarrollo Local - Yuno SDK Flutter

Este documento te guía para configurar y probar el SDK de Yuno localmente.

## 📋 Prerrequisitos

1. **Flutter SDK** (versión 3.6.0 o superior)
   ```bash
   # Verificar instalación
   flutter --version
   flutter doctor
   ```

2. **Dart SDK** (incluido con Flutter)

3. **Xcode** (para iOS) o **Android Studio** (para Android)

## 🚀 Configuración Inicial

### 1. Instalar Melos (Gestor de Monorepo)

```bash
# Instalar Melos globalmente
dart pub global activate melos

# Verificar instalación
melos --version
```

### 2. Configurar el Proyecto

```bash
# Navegar al directorio del proyecto
cd /path/to/yuno-sdk-flutter

# Ejecutar el script de configuración
./setup_local.sh

# O manualmente:
melos bootstrap
cd example
flutter pub get
```

### 3. Configurar Credenciales

Edita el archivo `example/lib/environments.dart` y reemplaza los valores por defecto:

```dart
class Environments {
  static const apiKey = String.fromEnvironment(
    'YUNO_API_KEY',
    defaultValue: 'tu_api_key_real_aqui', // ← Reemplaza esto
  );
  
  static const checkoutSession = String.fromEnvironment(
    'YUNO_CHECKOUT_SESSION',
    defaultValue: 'tu_checkout_session_aqui', // ← Reemplaza esto
  );
}
```

**O usando variables de entorno:**

```bash
# Crear archivo .env en el directorio example/
echo "YUNO_API_KEY=tu_api_key_aqui" > example/.env
echo "YUNO_CHECKOUT_SESSION=tu_checkout_session_aqui" >> example/.env

# Ejecutar con variables de entorno
cd example
flutter run --dart-define-from-file=.env
```

## 🏃‍♂️ Ejecutar la Aplicación de Ejemplo

### Para iOS:
```bash
cd example
flutter run -d ios
```

### Para Android:
```bash
cd example
flutter run -d android
```

### Para Web (si está habilitado):
```bash
cd example
flutter run -d chrome
```

## 🔧 Desarrollo del SDK

### Estructura del Proyecto

```
yuno-sdk-flutter/
├── yuno_sdk/                 # SDK principal
├── yuno_sdk_core/           # Funcionalidades core
├── yuno_sdk_android/        # Implementación Android
├── yuno_sdk_foundation/     # Implementación iOS
├── yuno_sdk_platform_interface/ # Interfaz de plataforma
└── example/                 # Aplicación de ejemplo
```

### Comandos Útiles

```bash
# Bootstrap del monorepo (instalar dependencias)
melos bootstrap

# Ejecutar tests en todos los paquetes
melos test

# Limpiar todos los paquetes
melos clean

# Obtener dependencias en todos los paquetes
melos pub get

# Ejecutar análisis de código
melos analyze
```

### Desarrollo Iterativo

1. **Modificar código del SDK**: Los cambios en `yuno_sdk/` se reflejan automáticamente en `example/`
2. **Hot Reload**: Usa `r` en la terminal donde corre `flutter run`
3. **Hot Restart**: Usa `R` para reiniciar completamente

### Testing

```bash
# Tests unitarios
cd yuno_sdk
flutter test

# Tests de integración
cd example
flutter test integration_test/

# Coverage
melos test  # Genera reporte de cobertura
```

## 📱 Funcionalidades Disponibles

La aplicación de ejemplo incluye:

- **YunoPaymentMethods**: Widget para mostrar métodos de pago
- **startPaymentLite()**: Iniciar pago con método específico
- **startPayment()**: Iniciar flujo de pago completo

## 🐛 Debugging

### Logs del SDK

El SDK usa un logger personalizado. Para ver logs:

```bash
# En iOS
flutter logs --device-id=<ios-device-id>

# En Android
flutter logs --device-id=<android-device-id>
```

### Problemas Comunes

1. **Error de API Key**: Verifica que la API key sea válida
2. **Checkout Session inválido**: Asegúrate de usar un checkout session activo
3. **Dependencias**: Ejecuta `melos bootstrap` si hay problemas de dependencias

## 🔗 Enlaces Útiles

- [Documentación de Yuno](https://docs.y.uno/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Melos Documentation](https://melos.invertase.dev/)

## 📞 Soporte

Si encuentras problemas:

1. Revisa los logs de la aplicación
2. Verifica la configuración de credenciales
3. Consulta la documentación oficial de Yuno
4. Ejecuta `flutter doctor` para verificar el entorno
