# CLAUDE.md — Yuno Flutter SDK

## What is this repo?

Monorepo del **Yuno Flutter SDK** (`yuno` en pub.dev). Permite integrar pagos nativos (Android/iOS) en apps Flutter. Wrappea los SDKs nativos de Yuno (Android SDK 2.12.0, iOS SDK 2.13.1).

## Estructura del repo

```
yuno_sdk/           # Paquete principal del SDK (se publica como "yuno" en pub.dev)
  ├── lib/src/
  │   ├── channels/       # Method channels (comunicación Flutter <-> nativo)
  │   ├── platform_interface/  # Capa de abstracción de plataforma
  │   └── widgets/        # Widgets públicos (YunoPaymentMethods, listeners)
  ├── android/            # Implementación nativa Android (Kotlin)
  ├── ios/                # Implementación nativa iOS (Swift)
  └── test/               # Tests unitarios
example/            # App de ejemplo básica
yuno-flutter-qa-app/  # App QA con todas las features (Riverpod, Firebase)
melos.yaml          # Configuración del monorepo
```

## Arquitectura del SDK

```
API pública (Yuno class) → Platform Interface → Method Channels → Nativo (Kotlin/Swift)
```

- **Clase principal:** `Yuno` en `yuno_sdk/lib/src/channels/yuno_channels.dart`
- **Métodos clave:** `init()`, `startPayment()`, `startPaymentLite()`, `enrollmentPayment()`, `continuePayment()`, `startPaymentSeamlessLite()`
- **Widgets:** `YunoPaymentMethods`, `YunoPaymentListener`, `YunoEnrollmentListener`, `YunoMultiListener`
- **Extension en BuildContext:** `context.startPayment(...)`, `context.startPaymentLite(...)`, etc.

## Distribución

- Se publica en **pub.dev** como paquete `yuno`
- Instalación: `flutter pub add yuno`
- Plataformas: Android (SDK 21+), iOS (14.0+)
- Requiere Dart >=3.6.0, Flutter >=3.3.0

## Integración típica

1. Agregar dependencia: `yuno: ^1.0.5`
2. Llamar `Yuno.init(apiKey, countryCode, config)` al inicio
3. Usar `YunoPaymentMethods` widget para mostrar métodos de pago
4. Llamar `Yuno.startPayment()` o `context.startPayment()` para iniciar flujo
5. Escuchar resultados con `YunoPaymentListener`

## Comandos útiles

```bash
# Setup inicial
./setup_local.sh
melos bootstrap

# Tests
melos run test          # Tests con cobertura

# Calidad de código
melos run format        # Formatear
melos run analyze       # Análisis estático
```

## Convenciones

- Monorepo gestionado con **Melos**
- Tests con **mocktail**
- Branch principal: `master`
- PRs siguen template en `.github/PULL_REQUEST_TEMPLATE.md`
- Cada feature nativa tiene: handler, models, parsers, keys
