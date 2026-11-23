# Lotería Push 🐓

Notificaciones push (Firebase Cloud Messaging) en Flutter, con un cantor de Lotería en un servidor Node.
Manual de Desarrollo Móvil Integral, UTNG.

```
loteria_push/
  server/   el cantor (Node, sin dependencias para correr las pruebas)
  app/      la app Flutter
```

## 1. Servidor (necesita Node 20 o más nuevo)

```bash
cd server
npm test          # 61 pruebas, deben pasar todas
npm start         # cantor en http://localhost:8080 con push SIMULADO (se imprime en consola)
```

No necesita Firebase para jugar: cada push que se habría enviado sale en la consola.

## 2. App Flutter (una sola vez)

Desde la carpeta `app/`:

```bash
flutter create . --project-name loteria_push   # genera android/ e ios/ (no pisa lib/ ni pubspec.yaml)
dart tool/configurar.dart                      # permisos, canal y desugaring de Android
flutter pub get
flutter test                                   # las pruebas NO necesitan Firebase
```

> Si `dart tool/configurar.dart` falla, los cambios a mano están en la Ronda 1 del manual
> (AndroidManifest.xml y android/app/build.gradle.kts). Borra también `test/widget_test.dart`
> si `flutter create` lo generó.

## 3. Firebase (solo para correr la app, no para las pruebas)

```bash
npm install -g firebase-tools && firebase login
dart pub global activate flutterfire_cli
flutterfire configure        # genera lib/firebase_options.dart
flutter run --dart-define=SERVIDOR=http://10.0.2.2:8080
```

- Sin `lib/firebase_options.dart` la app no compila (`flutter analyze` marcará ese error), pero `flutter test` sí corre.
- `10.0.2.2` es el "localhost" del emulador Android. En un teléfono real usa la IP de tu compu (ej. `http://192.168.1.50:8080`).
- Para push de verdad: `npm install firebase-admin`, `GOOGLE_APPLICATION_CREDENTIALS=/ruta/cuenta.json`
  y `FCM_REAL=1 FCM_DRY_RUN=1 npm start` (valida sin entregar). Quita `FCM_DRY_RUN` para entregar.
  El JSON de la cuenta de servicio **nunca** va dentro de la app ni del repositorio.

## Cambios respecto al manual

- `app/test/pantalla_test.dart`: la función `abrir` fija una pantalla de prueba de 400x1000. Con los 800x600 por
  defecto, el `ListView` no construye el botón ni el aviso de ganador (quedan muy abajo) y las pruebas no los encuentran.
- `app/tool/configurar.dart`: script extra para aplicar la configuración de Android.

Ver `GUIA_PRUEBAS_Y_CAPTURAS.md` para los comandos de pruebas y capturas.

## 4. Generar el APK para tu celular

1. **Servidor en tu compu** (el celular se conecta a él por wifi): `cd server && npm start`.
2. Averigua la IP de tu compu en la misma red wifi que el celular (`ipconfig` en Windows, busca "Dirección IPv4", ej. `192.168.1.50`).
   Permite el puerto 8080 en el firewall de Windows si te lo pregunta.
3. Compila el APK con esa IP metida (dentro de `app/`):

```bash
flutter build apk --release --dart-define=SERVIDOR=http://192.168.1.50:8080
```

4. El archivo queda en `app/build/app/outputs/flutter-apk/app-release.apk`. Pásalo al celular (cable, Drive o WhatsApp),
   ábrelo y acepta "instalar apps de origen desconocido". Con el cable y la depuración USB activada también puedes usar
   `flutter install` o `flutter run --release`.

Notas:
- `10.0.2.2` solo sirve en el emulador; en el celular siempre usa la IP de tu compu. Si cambias de red, la IP cambia y hay que recompilar.
- Con el servidor en modo simulado (`npm start` normal) no salen push reales. Para probar la app en el celular sin Firebase de servidor,
  responde "Mejor no" a los avisos: la app revisa al cantor cada 5 s y el juego funciona.
- Para push de verdad: `npm install firebase-admin` en `server/`, descarga la cuenta de servicio (Firebase, Configuración, Cuentas de servicio)
  y en PowerShell: `$env:GOOGLE_APPLICATION_CREDENTIALS="C:\ruta\cuenta.json"; $env:FCM_REAL="1"; npm start`.
  Ese JSON nunca va dentro de la app ni en GitHub.
