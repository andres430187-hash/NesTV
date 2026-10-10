# NesTV 📺

Cliente IPTV multiplataforma en **Flutter** con estética oscura
(#000000 / #121212) y acentos en verde flúor (#00FF66).
Compatible con paneles **Xtream Codes API**.

## Características
- 🔐 Login conectado a `/player_api.php` (usuario, contraseña, URL de servidor)
- 📺 Categorías de **TV en Vivo**, **Películas (VOD)** y **Series**
- ▶️ Reproductor de video integrado

## Instalación
```bash
git clone https://github.com/andres430187-hash/NesTV.git
cd NesTV
flutter pub get
flutter create .   # solo si faltan carpetas android/ios/web
flutter run
