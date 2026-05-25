# SwimStrength AI

App de preparación para triatlón (700 m natación · 40 km bici · 10 km carrera).

Pantallas:
- **Entrenamiento de hoy** — checklist con vídeos de técnica. El estado se guarda en el dispositivo.
- **Plan semanal** — rutina lunes a domingo.
- **Recovery** — sueño y movilidad.
- **Garmin Analytics** — feedback manual.

Construida con Flutter (Material 3, tema oscuro). Se distribuye como **PWA** instalable en iPhone — no necesita App Store.

## Stack

- Flutter 3.x / Dart 3.11+
- `shared_preferences` (persistencia local)
- `url_launcher` (abrir vídeos)

Carpetas relevantes:
```
lib/
  main.dart
  models/exercise.dart
  data/training_data.dart
  screens/
    dashboard_screen.dart
    training_screen.dart
    weekly_plan_screen.dart
    recovery_screen.dart
    analytics_screen.dart
web/                      ← entrada PWA (manifest, index, icons)
```

## Desarrollo local

```bash
flutter pub get
flutter run -d chrome         # navegador
flutter test                  # tests
flutter analyze               # lint
```

## Build PWA

```bash
flutter build web --release --base-href /frontend_flutter/
```

Salida: `build/web/`. Si despliegas en raíz de dominio usa `--base-href /`.

Servir en local:
```bash
cd build/web
python -m http.server 8080
```

## Instalar en iPhone (PWA)

1. Despliega `build/web/` (ver siguiente sección).
2. Abre la URL en **Safari** del iPhone (no Chrome — Safari es el único que instala PWAs en iOS).
3. Toca **Compartir** → **Añadir a pantalla de inicio**.
4. Aparece icono "SwimStrength" en home — se abre a pantalla completa, sin barra Safari.

Los checkboxes de "Entrenamiento de hoy" se conservan entre sesiones (localStorage).

## Subir a GitHub + desplegar en GitHub Pages

Una vez creado el repo (`https://github.com/<usuario>/frontend_flutter`):

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/<usuario>/frontend_flutter.git
git push -u origin main
```

El workflow `.github/workflows/deploy.yml` se dispara en cada push a `main`:
1. Compila `flutter build web --base-href /frontend_flutter/`.
2. Publica `build/web/` en la rama `gh-pages`.

**Activar GitHub Pages** una sola vez:
- Repo → Settings → Pages → Source: `Deploy from a branch` → Branch: `gh-pages` / root.
- URL pública: `https://<usuario>.github.io/frontend_flutter/`.

Abre esa URL en Safari del iPhone y añade a pantalla inicio.

> Si tu repo se llama distinto, cambia `--base-href /<repo>/` en el workflow.

## Limitaciones PWA en iOS

- `url_launcher` abre el vídeo en pestaña Safari nueva (no en la app).
- No hay push notifications nativas.
- No hay acceso a HealthKit/Garmin: los datos de "Analytics" son manuales.
- Para acceso nativo (HealthKit, sensores) habría que compilar `.ipa` con Mac+Xcode o Codemagic.
