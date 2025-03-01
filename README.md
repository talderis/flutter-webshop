# Modern Webshop

Modern, Flutter alapú webshop alkalmazás, amely bemutatja a modern mobilalkalmazás-fejlesztés alapelveit.

## APK fájl elérési útja

A telepíthető APK fájl itt található: `build\app\outputs\flutter-apk\app-release.apk`

## Funkciók

- Termékek böngészése kategóriák szerint
- Termékek részletes megtekintése
- Kosár kezelése
- Felhasználói profil
- Bejelentkezés és regisztráció
- Kedvencek kezelése
- Rendelési előzmények megtekintése
- Sötét téma támogatás

## Telepítés

### Előfeltételek

- Flutter SDK (2.0.0 vagy újabb)
- Dart SDK (2.12.0 vagy újabb)
- Android Studio / VS Code Flutter és Dart bővítményekkel

### Telepítés lépései

1. Klónozd a repository-t:
```
git clone https://github.com/talderis/modern-webshop.git
```

2. Navigálj a projekt mappájába:
```
cd modern-webshop
```

3. Telepítsd a függőségeket:
```
flutter pub get
```

4. Indítsd el az alkalmazást:
```
flutter run
```

## Használat

Az alkalmazás négy fő részből áll:

1. **Főoldal**: Kiemelt termékek és kategóriák böngészése
2. **Termékek**: Összes termék böngészése kategóriák szerint
3. **Kosár**: A kosárba helyezett termékek kezelése
4. **Profil**: Felhasználói beállítások és rendelési előzmények

## Technológiák

- Flutter
- Provider állapotkezelés
- Firebase autentikáció (mock implementáció)
- Material Design 3

## Készítette

Készítette: Búzás Barnabás (talderis)

## Licenc

Ez a projekt MIT licenc alatt áll - további részletekért lásd a LICENSE fájlt.
