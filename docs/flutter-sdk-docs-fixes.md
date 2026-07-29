# Fixes para la documentación del Flutter SDK

**Página:** https://docs.y.uno/docs/sdks/additional-platforms/flutter
**Revisado contra:** `yuno` pub `1.0.17` · Android native `2.17.3` · iOS native `2.18.0`
**Fecha:** 2026-07-29

Este documento lista los cambios necesarios para alinear la doc pública con el código real del SDK. Cada fix indica lo que dice la doc hoy (❌) y el contenido corregido listo para pegar (✅), con la referencia al código fuente.

---

## Índice de fixes

| # | Tipo | Sección | Severidad |
|---|------|---------|-----------|
| 1 | Error | `YunoConfig` (snippet incorrecto) | 🔴 Alta — no compila |
| 2 | Error | Personalización Android desactualizada | 🟠 Media |
| 3 | Incompleto | Tabla de idiomas (7 → 11) | 🟠 Media |
| 4 | Falta | Setup iOS + deeplinks | 🔴 Alta — rompe iOS |
| 5 | Falta | Flujo Full checkout + `YunoPaymentMethods` | 🟠 Media |
| 6 | Falta | Flujo Seamless | 🟠 Media |
| 7 | Falta | `hideLoader()` / `keepLoader` / `androidConfig` | 🟡 Baja |
| 8 | Desactualizado | Requisitos de toolchain | 🟡 Baja |

---

## Fix 1 — `YunoConfig` (snippet incorrecto) 🔴

La doc muestra una clase tipo Kotlin con el campo `saveCardEnabled` (con "d" final) y omite el resto de campos. **Copiado literal no compila.**

**❌ Actual (doc):**
```kotlin
class YunoConfig {
  bool saveCardEnabled;
  YunoConfig({
    this.saveCardEnabled = false,
  });
}
```

**✅ Corregido** — clase **Dart** real ([`yuno_config.dart`](../yuno_sdk/lib/src/platform_interface/features/init/models/yuno_config.dart)):
```dart
class YunoConfig {
  const YunoConfig({
    this.lang = YunoLanguage.en,   // idioma de TODA la UI del SDK
    this.saveCardEnable = false,   // ojo: sin la "d" final
    this.keepLoader = false,       // mantiene el loader visible durante el flujo
    this.appearance,               // personalización cross-platform (iOS + Android)
  });

  final YunoLanguage lang;
  final bool saveCardEnable;
  final bool keepLoader;
  final Appearance? appearance;
}
```

**✅ Uso recomendado en `Yuno.init`:**
```dart
await Yuno.init(
  apiKey: 'YOUR_PUBLIC_API_KEY',
  countryCode: 'CO',
  yunoConfig: const YunoConfig(
    lang: YunoLanguage.es,
    saveCardEnable: true,
    keepLoader: false,
  ),
  iosConfig: const IosConfig(),
  androidConfig: const AndroidConfig(),
);
```

> **El idioma se setea una sola vez aquí.** `YunoConfig.lang` se envía al SDK nativo en `initialize` y aplica a todos los flujos (Full, Lite, enrollment, render). Si se omite, cae al default `YunoLanguage.en`.

---

## Fix 2 — Personalización Android desactualizada 🟠

La doc dice que en Android la personalización se hace solo vía `YunoStyles` / `YunoButtonStyles` nativos en el init. El SDK Flutter ya expone personalización desde Dart.

**✅ Agregar:**
- `YunoConfig(appearance: Appearance(...))` — cross-platform (iOS + Android).
- `AndroidConfig(appearance: Appearance(...))` — específico de Android; tiene prioridad sobre `YunoConfig.appearance` en Android.
- `IosConfig(appearance: Appearance(...))` — específico de iOS; tiene prioridad sobre `YunoConfig.appearance` en iOS.

Regla de prioridad (ver [`yuno_method_channel.dart:134-142`](../yuno_sdk/lib/src/platform_interface/yuno_method_channel.dart)):
`IosConfig.appearance` / `AndroidConfig.appearance` **>** `YunoConfig.appearance`.

> ⚠️ **Nota para quien documente `Appearance`:** los nombres de los campos de color tienen un typo consolidado en la API (`Backgroun`, sin la "d"). Hay que documentarlos **tal cual** o no compilan: `buttonBackgrounColor`, `buttonTitleBackgrounColor`, `buttonBorderBackgrounColor`, `secondaryButtonBackgrounColor`, `secondaryButtonTitleBackgrounColor`, `secondaryButtonBorderBackgrounColor`, `disableButtonBackgrounColor`, `disableButtonTitleBackgrounColor`. Los correctos son `fontFamily`, `accentColor`, `checkboxColor`. Ver [`ios_config.dart`](../yuno_sdk/lib/src/platform_interface/features/init/models/ios_config.dart).

---

## Fix 3 — Tabla de idiomas (7 → 11) 🟠

La doc lista 7 idiomas. El enum `YunoLanguage` tiene **11** ([`yuno_language.dart`](../yuno_sdk/lib/src/core/src/enums/yuno_language.dart)).

**✅ Tabla completa:**

| Constante | Idioma |
|-----------|--------|
| `YunoLanguage.en` | English |
| `YunoLanguage.es` | Spanish |
| `YunoLanguage.pt` | Portuguese |
| `YunoLanguage.ms` | Malay |
| `YunoLanguage.id` | Indonesian |
| `YunoLanguage.th` | Thai |
| `YunoLanguage.ar` | Arabic |
| `YunoLanguage.hi` | Hindi |
| `YunoLanguage.bn` | Bengali |
| `YunoLanguage.ml` | Malayalam |
| `YunoLanguage.ur` | Urdu |

> ⚠️ **Bug de código (no de doc) a reportar aparte:** `YunoLanguage.ms` mapea a `rawValue = 'MW'`, así que al nativo le llega `'mw'`. Verificar si el nativo espera `'ms'`/`'my'`; de lo contrario, Malay no se aplica.

---

## Fix 4 — Setup iOS + deeplinks 🔴

La doc **no cubre iOS**. Sin el URL scheme + el ruteo del deeplink, el flujo de pago iOS (3DS/redirects) **se cuelga**.

**✅ 1) Registrar el URL scheme** en `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>yuno</string>
    </array>
  </dict>
</array>
```

**✅ 2) Rutear el deeplink a Yuno desde Dart** (patrón usado en el QA app, con el paquete [`app_links`](https://pub.dev/packages/app_links)) — ver [`yuno-flutter-qa-app/lib/main.dart`](../yuno-flutter-qa-app/lib/main.dart):
```dart
late AppLinks _appLinks;
StreamSubscription<Uri>? _linkSubscription;

Future<void> _initDeepLinks() async {
  _appLinks = AppLinks();

  // App abierta mediante deeplink
  final initialLink = await _appLinks.getInitialLink();
  if (initialLink != null) _handleDeepLink(initialLink);

  // App ya en ejecución
  _linkSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
}

void _handleDeepLink(Uri uri) {
  if (uri.scheme == 'yuno') {
    Yuno.receiveDeeplink(url: uri);
  }
}
```

> Requiere `minSdkVersion 21+` (Android) e `iOS 14.0+`. En Android el mismo scheme (`yuno`) se maneja vía el mismo listener de `app_links`.

---

## Fix 5 — Flujo Full checkout + `YunoPaymentMethods` 🟠

La doc solo documenta Lite. El SDK expone el flujo Full con el widget de render `YunoPaymentMethods` + `Yuno.startPayment()`.

**✅ Agregar** (patrón de [`example/lib/main.dart`](../example/lib/main.dart)):
```dart
// 1) Renderizar los métodos de pago
YunoPaymentMethods(
  config: PaymentMethodConf(
    checkoutSession: checkoutSessionId,
  ),
  listener: (context, methodSelected, height) {
    // methodSelected: método elegido por el usuario
    // height: alto del contenido para ajustar el layout
  },
)

// 2) Lanzar el pago Full
await Yuno.startPayment(showPaymentStatus: true);
```

Modelo `PaymentMethodConf` ([`payment_method_config.dart`](../yuno_sdk/lib/src/platform_interface/features/show_payment_methods/models/payment_method_config.dart)):
```dart
PaymentMethodConf({
  required String checkoutSession,
  String? countryCode,
})
```

---

## Fix 6 — Flujo Seamless 🟠

No documentado. `Yuno.startPaymentSeamlessLite` devuelve un `YunoStatus`.

**✅ Agregar** ([`yuno_channels.dart:208`](../yuno_sdk/lib/src/channels/yuno_channels.dart), [`seamless_arguments.dart`](../yuno_sdk/lib/src/platform_interface/features/seamless/model/seamless_arguments.dart)):
```dart
final YunoStatus status = await Yuno.startPaymentSeamlessLite(
  arguments: SeamlessArguments(
    checkoutSession: 'CHECKOUT_SESSION',
    methodSelected: const MethodSelected(
      vaultedToken: 'VAULTED_TOKEN',
      paymentMethodType: 'CARD',
    ),
    showPaymentStatus: true, // default true
  ),
);
```

> El idioma no se pasa aquí: se reutiliza el `YunoConfig.lang` definido en `Yuno.init`.

---

## Fix 7 — `hideLoader()` / `keepLoader` / `androidConfig` 🟡

**✅ `hideLoader()`** — oculta manualmente el loader del SDK:
```dart
await Yuno.hideLoader();
```

**✅ `keepLoader`** (en `YunoConfig`) — mantiene el loader visible durante el flujo; se combina con `hideLoader()` para control manual.

**✅ `androidConfig`** — parámetro de `Yuno.init` (par de `iosConfig`), hoy no documentado. Ver Fix 1 y Fix 2.

---

## Fix 8 — Requisitos de toolchain 🟡

**❌ Actual (doc):** Kotlin 1.4.0+, Gradle 4.0.0+, Java 8.

**✅ Corregido** (según [`android/build.gradle`](../yuno_sdk/android/build.gradle)):
- **Kotlin 1.9.25** (el plugin autodetecta Kotlin 2.x y activa el Compose Compiler plugin).
- **compileSdk 34**, **minSdk 21**.
- **Java 8** sigue siendo válido (`sourceCompatibility = VERSION_1_8`).
- iOS: **14.0+** (`s.platform = :ios, '14.0'`).

---

## Lo que ya está correcto (no tocar)

- `flutter pub add yuno`.
- `MainActivity : FlutterFragmentActivity()`.
- Clase `Application` con `YunoSdkAndroidPlugin.initSdk(this, "YUNO_API_KEY")`, paquete `com.yuno_flutter.yuno_sdk_android` (confirmado en el QA app: `MyApp.kt`).
- Repo Maven `https://yunopayments.jfrog.io/artifactory/snapshots-libs-release`.
- `Yuno.init(apiKey, countryCode, yunoConfig, iosConfig)` (agregar solo `androidConfig`).
- `startPaymentLite`, `continuePayment`, `enrollmentPayment`, `receiveDeeplink`.
- `YunoPaymentListener` → `state.token`; `YunoEnrollmentListener` → `state.enrollmentStatus`.
- `MethodSelected(paymentMethodType, vaultedToken?)`.
