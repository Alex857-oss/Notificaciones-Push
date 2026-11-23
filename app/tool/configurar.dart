// Configura Android (Ronda 1 del manual) después de `flutter create .`
// Uso (dentro de la carpeta app/):  dart tool/configurar.dart
// Es seguro correrlo varias veces: no duplica nada.
import 'dart:io';

const permisos = '''<uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    ''';

const canalPredeterminado = '''
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="cartas" />
    ''';

void main() {
  if (!Directory('android').existsSync()) {
    stderr.writeln('No existe la carpeta android/. Corre primero: flutter create . --project-name loteria_push');
    exit(1);
  }

  // 1) AndroidManifest.xml
  final manifest = File('android/app/src/main/AndroidManifest.xml');
  var m = manifest.readAsStringSync();
  if (!m.contains('android.permission.POST_NOTIFICATIONS')) {
    m = m.replaceFirst('<application', '$permisos<application');
    print('Manifest: permisos INTERNET y POST_NOTIFICATIONS agregados');
  }
  if (!m.contains('usesCleartextTraffic')) {
    // SOLO para desarrollo contra el servidor local por http. En producción usa https.
    m = m.replaceFirst('<application', '<application\n        android:usesCleartextTraffic="true"');
    print('Manifest: usesCleartextTraffic agregado (solo desarrollo)');
  }
  if (!m.contains('default_notification_channel_id')) {
    m = m.replaceFirst('</application>', '$canalPredeterminado</application>');
    print('Manifest: canal predeterminado "cartas" agregado');
  }
  manifest.writeAsStringSync(m);

  // 2) build.gradle(.kts) de la app: desugaring (lo pide flutter_local_notifications)
  final kts = File('android/app/build.gradle.kts');
  final groovy = File('android/app/build.gradle');
  if (kts.existsSync()) {
    var g = kts.readAsStringSync();
    if (!g.contains('isCoreLibraryDesugaringEnabled')) {
      g = g.replaceFirst('compileOptions {', 'compileOptions {\n        isCoreLibraryDesugaringEnabled = true');
    }
    if (!g.contains('coreLibraryDesugaring(')) {
      g += '\ndependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")\n}\n';
    }
    kts.writeAsStringSync(g);
    print('build.gradle.kts: desugaring listo');
  } else if (groovy.existsSync()) {
    var g = groovy.readAsStringSync();
    if (!g.contains('coreLibraryDesugaringEnabled')) {
      g = g.replaceFirst('compileOptions {', 'compileOptions {\n        coreLibraryDesugaringEnabled true');
    }
    if (!g.contains('coreLibraryDesugaring ')) {
      g += "\ndependencies {\n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'\n}\n";
    }
    groovy.writeAsStringSync(g);
    print('build.gradle: desugaring listo');
  } else {
    stderr.writeln('No encontré android/app/build.gradle(.kts)');
    exit(1);
  }

  // 3) flutter create trae una prueba de ejemplo que ya no aplica
  final ejemplo = File('test/widget_test.dart');
  if (ejemplo.existsSync()) {
    ejemplo.deleteSync();
    print('Borré test/widget_test.dart (prueba de ejemplo de flutter create)');
  }

  print('Listo. Siguiente: flutter pub get && flutter test');
}
